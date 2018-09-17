import Foundation

typealias JSONDictionary = [String: Any]

enum Resource {
    case cars
    
    private var baseUrlString: String {
        return "https://s3-us-west-2.amazonaws.com"
    }

    private var path: String {
        switch self {
        case .cars: return "/wunderbucket/locations.json"
        }
    }
    
    private var httpMethod: String {
        return "get"
    }
    
    private var url: URL {
        let url = baseUrlString + path
        return URL(string: url)!
    }
    
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: self.url)
        request.httpMethod = self.httpMethod
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
