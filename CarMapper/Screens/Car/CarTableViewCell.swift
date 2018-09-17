import SnapKit
import UIKit


class CarTableViewCell: UITableViewCell {
    
    //MARK: Constants
    
    static let CELL_HEIGHT: CGFloat = 120.0
    static let CELL_PADDING: CGFloat = 10.0
    static let MAX_FUEL_HEIGHT: CGFloat  = 80.0
    
    enum carPart {
        case interior, exterior
    }
    
    //MARK: Variables
    
    override var isSelected: Bool {
        didSet { self.setCellSelected(isSelected) }
    }
    
    var name: String? {
        didSet { self.nameLabel.text = "🚗 " + (name ?? "-") }
    }
    
    var address: String?{
        didSet { self.addressLabel.text = address }
    }
    
    var fuel: UInt? {
        didSet { self.setFuel(fuel) }
    }
    
    var interior: Condition? {
        didSet { self.setCondition(interior, carPart: .interior) }
    }
    
    var exterior: Condition? {
        didSet { self.setCondition(exterior, carPart: .exterior) }
    }
    
    //MARK: Private Variables
    
    private let nameLabel = UILabel(font: .title)
    private let addressLabel = UILabel(font: .subTitle)
    private let fuelLabel = UILabel(font: .footnote)
    private let fuelView = UIView()
    private let interiorLabel = UILabel(font: .body, text: "Interior: ")
    private let interiorIconLabel = UILabel(font: .body, text: "🤷🏻")
    private let exteriorLabel = UILabel(font: .body, text: "Exterior: ")
    private let exteriorIconLabel = UILabel(font: .body, text: "🤷🏾‍♂️")
    
    //MARK: Init Methods
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(fuelLabel)
        fuelLabel.snp.makeConstraints { make in
            make.right.bottom.equalTo(self).offset(-CarTableViewCell.CELL_PADDING)

        }
        
        let fuelContainer = UIView()
        fuelContainer.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        self.addSubview(fuelContainer)
        fuelContainer.snp.makeConstraints { make in
            make.centerX.equalTo(fuelLabel)
            make.bottom.equalTo(fuelLabel.snp.top).offset(-5)
            make.height.equalTo(CarTableViewCell.MAX_FUEL_HEIGHT)
            make.width.equalTo(30.0)
        }
        
        fuelContainer.addSubview(fuelView)
        fuelView.snp.makeConstraints { make in
            make.right.bottom.left.equalTo(fuelContainer)
            make.height.equalTo(1)
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(CarTableViewCell.CELL_PADDING)
            make.right.equalTo(fuelView.snp.left)
        }
        
        self.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
        }
        
        self.addSubview(interiorLabel)
        interiorLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-CarTableViewCell.CELL_PADDING)
            make.left.equalTo(nameLabel)
        }
        
        self.addSubview(interiorIconLabel)
        interiorIconLabel.snp.makeConstraints { make in
            make.centerY.equalTo(interiorLabel)
            make.left.equalTo(interiorLabel.snp.right)
            make.height.equalTo(interiorLabel)
        }
        
        self.addSubview(exteriorLabel)
        exteriorLabel.snp.makeConstraints { make in
            make.bottom.equalTo(interiorLabel.snp.top).offset(-5)
            make.left.equalTo(nameLabel)
            make.width.equalTo(interiorLabel)
        }
        
        self.addSubview(exteriorIconLabel)
        exteriorIconLabel.snp.makeConstraints { make in
            make.centerY.equalTo(exteriorLabel)
            make.left.equalTo(exteriorLabel.snp.right)
            make.height.equalTo(exteriorLabel)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isSelected = false
        nameLabel.text = nil
        addressLabel.text = nil
        fuelLabel.text = nil
        fuelView.isHidden = true
        interiorIconLabel.text = "🤷🏻"
        exteriorIconLabel.text = "🤷🏾‍♂️"
    }
}

//MARK: Private Helpers

extension CarTableViewCell {
    private func setCellSelected(_ isSelected: Bool) {
        super.isSelected = isSelected
        self.backgroundColor = isSelected ? #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func setCondition(_ condition: Condition?, carPart: carPart ) {
        guard let condition = condition else { return }
        
        let conditionLabel = condition == .good ? "👍" : "💩"
        
        if carPart == .interior {
            self.interiorIconLabel.text = conditionLabel
        } else if carPart == .exterior {
            self.exteriorIconLabel.text = conditionLabel
        }
    }
    
    private func setFuel(_ fuel: UInt?) {
        guard let fuel = fuel else {
            fuelLabel.text = "- %"
            fuelView.isHidden = true
            return
        }
        
        let percentage = fuel > 100 ? 100 : fuel
        let height = CarTableViewCell.MAX_FUEL_HEIGHT * 0.01 * CGFloat(percentage)
        
        fuelLabel.text = "\(percentage) %"
        fuelView.isHidden = false
        fuelView.backgroundColor = fuel < 30 ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0, green: 0.6144291162, blue: 0, alpha: 1)
        
        self.fuelView.snp.updateConstraints({ $0.height.equalTo(height) })
    }
}
