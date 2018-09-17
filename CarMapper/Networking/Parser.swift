import Foundation

struct Parser {
    static func parse<T: Codable>(_ completion: @escaping (T?, APIError?) -> Void) {
        FileHandler().read { data, error in
            guard let data = data, let object = try? JSONDecoder().decode(T.self, from: data) else {
                completion(nil, .other)
                return
            }
            
            completion(object, nil)
        }
    }
}
