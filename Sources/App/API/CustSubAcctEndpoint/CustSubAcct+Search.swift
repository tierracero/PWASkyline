import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

extension CustSubAcctComponents {
    /// An empty list is a successful search; nil indicates a request or decoding failure.
    public static func search(
        custAcct: UUID,
        term: String,
        callback: @escaping (_ term: String, _ response: [CustSubAcct]?) -> Void
    ) {
        let payload = SearchRequest(custAcct: custAcct, term: term)

        let queryCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        
        guard let encodedAccount = payload.custAcct.uuidString.addingPercentEncoding(withAllowedCharacters: queryCharacters),
              let encodedTerm = payload.term.addingPercentEncoding(withAllowedCharacters: queryCharacters) else {
            callback(term, nil)
            return
        }

        var server = "https://api.tierracero.co"
        switch developmentMode {
        case .local:
            server = "https://localhost:8800/api"
        case .develpment:
            server = "https://dev.tierracero.co/api"
        case .produccion:
            break
        }

        let url = baseAPIUrl("\(server)/\(endpoint)/search") +
            "&custAcct=\(encodedAccount)&term=\(encodedTerm)"
        let xhr = XMLHttpRequest()
        var hasCompleted = false
        let complete: ([CustSubAcct]?) -> Void = { response in
            guard !hasCompleted else { return }
            hasCompleted = true
            callback(term, response)
        }

        xhr.open(method: "GET", url: url)
        xhr.jsValue.timeout = Double(120_000).jsValue
        xhr.setRequestHeader("Accept", "application/json")
            .setRequestHeader("Content-Type", "application/json")
            .setRequestHeader("AppName", applicationName)
            .setRequestHeader("AppVersion", SkylineWeb().version.description)
            .setRequestHeader("WSId", custCatchChatConnID)

        xhr.onError { complete(nil) }
        xhr.onTimeout { complete(nil) }
        xhr.onAbort { complete(nil) }
        xhr.onLoad {
            guard (200..<300).contains(xhr.status),
                  let data = xhr.responseText?.data(using: .utf8) else {
                complete(nil)
                return
            }

            do {
                complete(try decodeAPIResponse([CustSubAcct].self, from: data))
            } catch {
                complete(nil)
            }
        }

        xhr.send()
    }
}
