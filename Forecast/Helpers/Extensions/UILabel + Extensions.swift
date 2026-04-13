import UIKit

extension UILabel {
    func configure(
        text: String? = nil,
        font: UIFont = .systemFont(ofSize: 14, weight: .regular),
        textColor: UIColor? = .customText,
        numberOfLines: Int = 0,
        alignment: NSTextAlignment = .center
    ) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.textAlignment = alignment
    }
}
