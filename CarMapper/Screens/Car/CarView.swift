import MapKit
import UIKit

class CarView: UIView {
    
    //MARK: Private Variables
    
    private let carCellReuseIdentifier = "carCellReuseIdentifier"
    
    private let tableView = UITableView()
    let mapView = MKMapView()
    
    //MARK: Init Methods
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    init(_ delegate: UITableViewDelegate & UITableViewDataSource & MKMapViewDelegate) {
        super.init(frame: .null)
        
        mapView.delegate = delegate
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.mapType = .mutedStandard
        mapView.register(
            CarAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: CarAnnotation.carAnnotationIdentifier)
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: CarAnnotation.carClusterAnnotationIdentifier)
        self.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.bottom.equalTo(self.snp.centerY)
        }
        
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.rowHeight = CarTableViewCell.CELL_HEIGHT
        tableView.allowsMultipleSelection = false
        tableView.register(CarTableViewCell.self,
                           forCellReuseIdentifier: carCellReuseIdentifier)
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.left.bottom.right.equalTo(self)
        }
    }
}

//MARK: Internal Methods

extension CarView {
    func dequeCellForIndexPath(_ indexPath: IndexPath) -> CarTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: carCellReuseIdentifier,
                                             for: indexPath) as! CarTableViewCell
    }
    
    func viewForAnnotation(_ annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is MKUserLocation:
            return nil
        case is CarAnnotation:
            return self.annotationViewForCarAnnotation(annotation as! CarAnnotation)
        case is MKClusterAnnotation:
            return self.annotationViewForClusterAnnotation(annotation as! MKClusterAnnotation)
        default:
            return nil
        }
    }
    
    func addCarAnnotations(_ annotations: [CarAnnotation]) {
        self.mapView.addAnnotations(annotations)
    }
    
    func removeCarAnnotations(_ annotations: [CarAnnotation]) {
        self.mapView.removeAnnotations(annotations)
    }
}

//MARK: Private Methods

extension CarView {
    private func annotationViewForCarAnnotation(_ carAnnotation: CarAnnotation) -> CarAnnotationView {
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: CarAnnotation.carAnnotationIdentifier,
            for: carAnnotation)  as! CarAnnotationView
        view.clusteringIdentifier = CarAnnotation.carClusterAnnotationIdentifier
        view.titleLabel.text = carAnnotation.title
        return view
    }
    
    private func annotationViewForClusterAnnotation(_ clusterAnnotation: MKClusterAnnotation) -> MKAnnotationView? {
        let view = self.mapView.dequeueReusableAnnotationView(
            withIdentifier: CarAnnotation.carClusterAnnotationIdentifier,
            for: clusterAnnotation) as? MKMarkerAnnotationView
        view?.canShowCallout = false
        view?.titleVisibility = .hidden
        return view
    }
}
