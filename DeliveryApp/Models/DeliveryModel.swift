import Foundation
struct DeliveryModel: Codable {
    let deliveryId: Int?
    let deliveryDescription: String?
    let imageURL: String?
    let location: Location?
    enum CodingKeys: String, CodingKey {
        case deliveryId = "id"
        case deliveryDescription = "description"
        case imageURL = "imageUrl"
        case location
    }
}
// MARK: - Location
struct Location: Codable {
    let lat, lng: Double?
    let address: String?
}
