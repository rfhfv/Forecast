import UIKit

extension UIView {
    func addCustomSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
