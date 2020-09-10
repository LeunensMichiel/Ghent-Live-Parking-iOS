import Foundation

struct ParkingList: Codable {
    let records: [Records]?
}

struct Records: Codable {
    let fields: Parking?
}

struct Parking: Codable {
    let id: String?
    let name: String?
    let description: String?
    let totalcapacity: Int?
    let availablecapacity: Int?
    let geo_location: [Double]?
    let address: String?
    let contactinfo: String?
}
