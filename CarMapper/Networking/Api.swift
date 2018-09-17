import Foundation

protocol API {
    func cars(completion: @escaping (APIError?) -> Void)
}

final class APIAdapter: API {
    
    func cars(completion: @escaping (APIError?) -> Void)
    {
        let resource = Resource.cars
        Request.data(resource.asURLRequest()) { statusCode, data, error in
            Response.parse(statusCode: statusCode, data: data, error: error as NSError?, completion: completion)
        }
    }
}
