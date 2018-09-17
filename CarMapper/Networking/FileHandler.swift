import Foundation

struct FileHandler {
    private let file = "locations.json"
    private let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private func fileUrl() -> URL? {
        return dir?.appendingPathComponent(file)
    }
    
    func read(_ completion: (Data?, APIError?) -> Void) {
        do {
            let data = try Data(contentsOf: fileUrl()!, options: [])
            return completion(data, nil)
        } catch {
            return completion(nil, .other)
        }
    }
    
    func write(_ data: Data?, _ completion: (APIError?) -> Void) {
        do {
            try data?.write(to: fileUrl()!, options: [])
            return completion(nil)
        } catch {
            return completion(.other)
        }
    }
}
