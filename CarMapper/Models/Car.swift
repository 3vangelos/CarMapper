import MapKit

struct Car: Codable {
    let vin: String?
    let name: String?
    let address: String?
    let fuel: UInt?
    let coordinates: [Double]?
    let engineType: String?
    let interior: Condition?
    let exterior: Condition?
    
    func coordinate() -> CLLocationCoordinate2D? {
        guard let c = self.coordinates, c.count > 1 else { return nil }
        return CLLocationCoordinate2D(latitude: c[1], longitude: c[0])
    }
}
