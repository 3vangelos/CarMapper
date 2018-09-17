import Foundation

class CarViewModel {
    
    let api: API
    
    var numberOfCells: Int { return cars.count }
    
    func annotationsWithoutName(_ name: String) -> [CarAnnotation] {
        return allAnnotations.filter({ $0.title != name })
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    lazy var allAnnotations: [CarAnnotation] = []
    var cars: [Car] = [] {
        didSet {
            allAnnotations = cars
                .filter({ $0.coordinate() != nil })
                .map({ CarAnnotation(name: $0.name, coordinate: $0.coordinate()!) })
            self.reloadViewClosure?()
        }
    }
    
    var reloadViewClosure: (()->())?
    var showAlertClosure: (()->())?
    
    init( api: API = APIAdapter()) {
        self.api = api
        readInData()
    }
    
    func fetchData() {
        api.cars { error in
            if let error = error {
                self.alertMessage = error.message
            } else {
                self.readInData()
            }
        }
    }
    
    func readInData() {
        Parser.parse{ (result: Result?, error: APIError?) in
            if let error = error {
                self.alertMessage = error.message
            } else if let cars = result?.cars {
                self.cars = cars
            }
        }
    }
}
