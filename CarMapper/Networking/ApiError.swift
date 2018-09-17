import Foundation

enum APIError: Error {
    case noCars
    case noConn
    case other
    
    static func apiServiceErrorForHTTPStatus(statusCode: Int?, errorCode: Int?) -> APIError? {
        guard let statusCode = statusCode, 200..<400 ~= statusCode else { return errorForCode(errorCode) }
        return nil
    }
    
    static func errorForCode(_ errorCode: Int?) -> APIError {
        guard let errorCode = errorCode, NSURLErrorBadServerResponse..<NSURLErrorCancelled ~= errorCode else { return .other }
        
        return .noConn
    }
    
    var message: String {
        switch self {
        case .noCars:
            return "No cars"
        case .noConn:
            return "No connection"
        default:
            return "Some Error occured"
        }
    }
}
