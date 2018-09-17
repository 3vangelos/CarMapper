import XCTest
@testable import CarMapper

class CarViewModelTests: XCTestCase {

    var sut: CarViewModel!
    var apiMock: APIMock!
    
    override func setUp() {
        super.setUp()
        apiMock = APIMock()
        sut = CarViewModel(api: apiMock)
    }

    override func tearDown() {
        sut = nil
        apiMock = nil
        super.tearDown()
    }

    func testFetchCars() {
        sut.fetchData()
        
        XCTAssert(apiMock!.isFetchDataCalled)
    }
    
    func testSuccessfullyFetchCars() {
        //Given
        StubGenerator().writeStubsIntoFile()
        
        //When
        sut.fetchData()
        
        // Viemodel should now have all cars from the stub
        XCTAssert(sut.cars.count == 3)
    }
    
    func testCorrectCellAmount() {
        StubGenerator().writeStubsIntoFile()
        
        sut.fetchData()
        
        XCTAssert(sut.cars.count == sut.numberOfCells)
    }
    
    func testFailedToFetchCars() {
        let error = APIError.other
        sut.fetchData()
        apiMock.fetchFail(error)
        
        XCTAssertEqual( sut.alertMessage, error.message )
    }
}

class StubGenerator {
    func writeStubsIntoFile() {
        if let path = Bundle(for: type(of: self)).path(forResource: "cars", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            FileHandler().write(data) { error in
                if error != nil {
                    fatalError()
                }
            }
        } else {
            fatalError()
        }
    }
}
