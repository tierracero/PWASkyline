//
// TripControler+Avatar.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Web

let tripAvatarDefaultSource = "/skyline/media/commercial_trip.png"

func tripAvatarSource(_ avatar: String?) -> String {
    guard let avatar, !avatar.purgeSpaces.isEmpty else {
        return tripAvatarDefaultSource
    }

    return "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/\(avatar)"
}

func tripAvatarImage(_ avatar: String?) -> Img {
    Img()
        .src(tripAvatarSource(avatar))
        .custom("object-fit", "contain")
}

func uploadTripAvatar(
    file: File,
    eventId: UUID,
    id: UUID?,
    to: ImagePickerTo,
    progress: @escaping (String?) -> Void,
    completed: @escaping (String) -> Void
) {
    let xhr = XMLHttpRequest()

    xhr.onLoadStart {
        progress("0%")
    }

    xhr.onError { _ in
        progress(nil)
        showError(.comunicationError, .serverConextionError)
    }

    xhr.onLoadEnd {
        guard let responseText = xhr.responseText else {
            progress(nil)
            showError(.comunicationError, .serverConextionError)
            return
        }

        guard let data = responseText.data(using: .utf8) else {
            progress(nil)
            showError(.unexpectedResult, "No se pudo leer la respuesta de la carga")
            return
        }

        do {
            let response = try JSONDecoder().decode(
                APIResponseGeneric<API.custAPIV1.UploadManagerResponse>.self,
                from: data
            )

            guard response.status == .ok else {
                progress(nil)
                showError(.generalError, response.msg)
                return
            }

            guard let process = response.data else {
                progress(nil)
                showError(.unexpectedResult, "No se pudo cargar el avatar")
                return
            }

            switch process {
            case .processing:
                progress("Procesando...")

            case .processed(let payload):
                progress(nil)
                completed(payload.avatar)
            }
        }
        catch {
            progress(nil)
            showError(.unexpectedResult, "No se pudo procesar el avatar")
        }
    }

    xhr.upload.addEventListener(
        "progress",
        options: EventListenerAddOptions(
            capture: false,
            once: false,
            passive: false,
            mozSystemGroup: false
        )
    ) { event in
        let progressEvent = ProgressEvent(event.jsEvent)

        guard progressEvent.total > 0 else { return }

        progress(
            ((Double(progressEvent.loaded) / Double(progressEvent.total)) * 100)
                .toInt
                .toString + "%"
        )
    }

    let formData = FormData()
    let fileName = safeFileName(name: file.name, to: to, folio: nil)

    formData.append("eventid", eventId.uuidString)
    formData.append("to", to.rawValue)

    if let id {
        formData.append("id", id.uuidString)
    }

    formData.append("fileName", fileName)
    formData.append("file", file, filename: fileName)
    formData.append("connid", custCatchChatConnID)
    formData.append("remoteCamera", false.description)

    xhr.open(method: "POST", url: "https://api.tierracero.co/cust/v1/uploadManager")
    xhr.setRequestHeader("Accept", "application/json")
    xhr.setRequestHeader("WSId", custCatchChatConnID)

    if let jsonData = try? JSONEncoder().encode(APIHeader(
        AppID: thisAppID,
        AppToken: thisAppToken,
        url: custCatchUrl,
        user: custCatchUser,
        mid: custCatchMid,
        key: custCatchKey,
        token: custCatchToken,
        tcon: .web,
        applicationType: custCatchAccountType.sessionType
    )),
    let string = String(data: jsonData, encoding: .utf8),
    let encoded = string.data(using: .utf8)?.base64EncodedString() {
        xhr.setRequestHeader("Authorization", encoded)
    }

    xhr.send(formData)
}
