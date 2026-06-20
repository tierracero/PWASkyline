
import Foundation

struct ReverseGeocodedAddress: Codable {
    let coordinate: AppleMap.Coordinate?
    let formattedAddress: String?
    let name: String?
    let street: String?
    let streetName: String?
    let streetNumber: String?
    let colony: String?
    let city: String?
    let state: String?
    let country: String?
    let zip: String?
    
    var printableAddress: String {
        let streetValue = street?.isEmpty == false ? street : [streetName, streetNumber].compactMap { value in
            guard let value, !value.isEmpty else { return nil }
            return value
        }.joined(separator: " ")
        
        let address = [
            streetValue,
            colony,
            city,
            state,
            country,
            zip
        ].compactMap { value in
            guard let value, !value.isEmpty else { return nil }
            return value
        }.joined(separator: ", ")
        
        if !address.isEmpty {
            return address
        }
        
        return formattedAddress ?? name ?? ""
    }
}