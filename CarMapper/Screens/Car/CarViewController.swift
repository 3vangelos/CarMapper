import MapKit
import SnapKit
import UIKit

class CarViewController: UIViewController {
    
    //TODO: Remove Dummy Data, bind to real Data
    private lazy var cars = [Car(vin: "TEST1",
                            name: "This is the Test Car Nr. 1",
                            address: "Friedrichstraße 45, 10117 Berlin",
                            fuel: 83,
                            coordinates: [52.11, 13.0, 0],
                            engineType: "CE",
                            interior: .unacceptable,
                            exterior: .good),
                        Car(vin: "TEST2",
                            name: "This is the Test Car Nr. 2",
                            address: "Friedrichstraße 43, 10117 Berlin",
                            fuel: 23,
                            coordinates: [52.1, 13.0, 0],
                            engineType: "CE",
                            interior: .good,
                            exterior: .unacceptable)]
    
    private lazy var allAnnotations = [CarAnnotation(vin: cars.first!.vin!,
                                                title: cars.first!.name,
                                                coordinate: cars.first!.coordinate()!),
                                  CarAnnotation(vin: cars.last!.vin!,
                                                title: cars.last!.name,
                                                coordinate: cars.last!.coordinate()!)]
    
    //MARK: Private Variables
    
    private lazy var carView = CarView(self)
    
    //MARK: Init Methods
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    //MARK: View LifeCycle

    override func loadView() {
        self.view = carView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.carView.mapView.addAnnotations(allAnnotations)
    }
}

extension CarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.carView.dequeCellForIndexPath(indexPath)
        let car = self.cars[indexPath.row]
        cell.name = car.name
        cell.address = car.address
        cell.fuel = car.fuel
        cell.interior = car.interior
        cell.exterior = car.exterior
        return cell
    }
}

extension CarViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = self.carView.viewForAnnotation(annotation)
        if let view = view as? CarAnnotationView {
            view.tap.addTarget(self, action: #selector(didTapAnnotationView(_:)))
        }
        return view
    }
    
    @objc func didTapAnnotationView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? CarAnnotationView else { return }
        view.isSelected = !view.isSelected
        didTapOnCarAnnotationView(view)

    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? CarAnnotationView else { return }
        view.isSelected = true
        didTapOnCarAnnotationView(view)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let view = view as? CarAnnotationView else { return }
        view.isSelected = false
        didTapOnCarAnnotationView(view)
    }
    
    func didTapOnCarAnnotationView(_ view: CarAnnotationView) {
        if view.isSelected {
            self.carView.removeCarAnnotations(allAnnotations.filter({ $0.title != view.titleLabel.text }))
        } else {
            self.carView.addCarAnnotations(allAnnotations.filter({ $0.title != view.titleLabel.text }))
        }
    }
}
