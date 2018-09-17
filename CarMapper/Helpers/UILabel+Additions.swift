import UIKit

extension UILabel {
    convenience init(font: UIFont = .body,
                     color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                     align: NSTextAlignment = .left,
                     text: String? = nil) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = align
    }
}
