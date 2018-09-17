import Foundation

struct Response {
    
    static func parse(statusCode: StatusCode?,
                      data: Data?,
                      error: NSError?,
                      completion: @escaping (APIError?) -> Void) {
        if let error = APIError.apiServiceErrorForHTTPStatus(statusCode: statusCode, errorCode: error?.code) {
            completion(error)
        } else if let data = data {
            FileHandler().write(data, completion)
        } else {
            completion(.other)
        }
    }
}
