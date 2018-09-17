import Foundation

typealias StatusCode = Int

struct Request {
    
    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }()

    static func data(_ request: URLRequest, completion: @escaping (StatusCode?, Data?, Error?) -> Void) {
        session.dataTask(with: request) { data, response, error in
            completion(response?.statusCode(), data, error)
            }.resume()
    }
}

extension URLResponse {
    func statusCode() -> StatusCode? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
