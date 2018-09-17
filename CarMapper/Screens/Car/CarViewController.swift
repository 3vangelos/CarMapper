import MapKit
import SnapKit
import UIKit

class CarViewController: UIViewController {

    //MARK: Variables
    
    var vm: CarViewModel? {
        didSet {
            guard let vm = vm else { return }
            vm.reloadViewClosure = { [weak self] () in
                DispatchQueue.main.async {
                    self?.carView.reload()
                    self?.carView.addCarAnnotations(vm.allAnnotations)
                }
            }
            
            vm.showAlertClosure = { [weak self] () in
                DispatchQueue.main.async {
                    if let message = self?.vm?.alertMessage {
                        self?.showAlert( message )
                    }
                }
            }
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vm?.fetchData()
    }
}

extension CarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm?.numberOfCells ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.carView.dequeCellForIndexPath(indexPath)
        guard let car = self.vm?.cars[indexPath.row] else { return cell }
        
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
}

extension CarViewController {
    @objc
    private func didTapAnnotationView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? CarAnnotationView else { return }
        view.isSelected = !view.isSelected
        didTapOnCarAnnotationView(view)
    }
    
    private func didTapOnCarAnnotationView(_ view: CarAnnotationView) {
        guard let name = view.titleLabel.text,
            let annotations = self.vm?.annotationsWithoutName(name) else {
                return
        }
        
        if view.isSelected {
            self.carView.removeCarAnnotations(annotations)
        } else {
            self.carView.addCarAnnotations(annotations)
        }
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
