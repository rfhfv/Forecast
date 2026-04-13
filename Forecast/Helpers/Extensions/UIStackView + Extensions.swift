import UIKit

extension UIStackView {
    func addCustomArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
