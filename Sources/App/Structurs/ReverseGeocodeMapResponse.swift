
import Foundation

struct ReverseGeocodeMapResponse: Codable {
    let status: String
    let msg: String?
    let addresses: [ReverseGeocodedAddress]?
}
