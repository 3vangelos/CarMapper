import MapKit

class CarAnnotation: MKPointAnnotation {

    static let carAnnotationIdentifier = "carAnnotationIdentifier"
    static let carClusterAnnotationIdentifier = "carClusterAnnotationIdentifier"

    init(name: String?, coordinate: CLLocationCoordinate2D) {
        super.init()
        
        super.title = name ?? "No Name"
        super.coordinate = coordinate
    }
}
