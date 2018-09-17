import XCTest
@testable import CarMapper

class APIMock: API {
    
    var isFetchDataCalled = false
    
    var completeFetch: ((APIError?) -> ())!
    
    func cars(completion: @escaping (APIError?) -> Void) {
        isFetchDataCalled = true
        completeFetch = completion
    }

    func fetchFail(_ error: APIError?) {
        completeFetch( error )
    }
}
