import Foundation

struct Result {
    let cars: [Car]?
    
    enum CodingKeys : String, CodingKey {
        case cars = "placemarks"
    }
}

extension Result: Codable {
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let cars = try values.decode([Car].self, forKey: .cars)
            self.init(cars: cars)
        } catch {
            self.init(cars: nil)
        }
    }
}
