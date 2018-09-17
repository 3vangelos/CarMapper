import MapKit

class CarAnnotationView: MKAnnotationView {
    
    //MARK: Variables
    
    // non-standard behaviour: Also detect taps on a selcted Annotation
    let tap = UITapGestureRecognizer()
    
    let titleLabel = UILabel(font: .footnote)
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set(newValue) {
            super.isSelected = newValue
            titleLabel.isHidden = !newValue
            self.image = newValue ? #imageLiteral(resourceName: "car_selected")  : #imageLiteral(resourceName: "car")
        }
    }
    
    //MARK: Init Methods
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        initReuseProperties()
        self.canShowCallout = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.red
        titleLabel.backgroundColor = UIColor.white
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.top).offset(-4)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initReuseProperties()
    }
}

//MARK: Private Helpers

extension CarAnnotationView {
    private func initReuseProperties() {
        self.image = #imageLiteral(resourceName: "car")
        self.isSelected = false
        self.titleLabel.isHidden = true
        self.titleLabel.text = nil
    }
}
