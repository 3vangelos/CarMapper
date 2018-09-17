import MapKit

class CarAnnotation: MKPointAnnotation {

    static let carAnnotationIdentifier = "carAnnotationIdentifier"
    static let carClusterAnnotationIdentifier = "carClusterAnnotationIdentifier"
    
    private let vin: String
    
    init(vin: String, title: String?, coordinate: CLLocationCoordinate2D) {
        self.vin = vin
        
        super.init()
        
        super.title = title ?? "No Title"
        super.coordinate = coordinate
    }
}
