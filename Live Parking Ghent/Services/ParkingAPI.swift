import Foundation

final class ParkingAPI {
    static let parkingAPI = ParkingAPI()
    static let urlSession = URLSession(configuration: .default)

    
    func fetchParkingList(onComplete: @escaping ([Parking]) -> ()) {
        // TODO: - Don't Hardcode URL
        let urlString = "https://data.stad.gent/api/records/1.0/search/?dataset=bezetting-parkeergarages-real-time"
        guard let url = URL(string: urlString) else {
            return print("Error with fetching URL")
        }
        
        let task = ParkingAPI.urlSession.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return print("Data was nil")
            }
            
            guard let parkingList = try? JSONDecoder().decode(ParkingList.self, from: data) else {
                return print("Error decoding JSON")
            }
            
            var finalList: [Parking] = []
            for record in parkingList.records! {
                finalList.append(record.fields!)
            }
            
            onComplete(finalList)
        }
        
        task.resume()
    }
}
 
