import UIKit

extension UIColor {
    static var customLight: UIColor { UIColor(named: "Light") ?? .white }
    static var customDark: UIColor { UIColor(named: "Dark") ?? .black }
    static var customLightGray: UIColor { UIColor(named: "Light Gray") ?? .lightGray }
    static var customDarkGray: UIColor { UIColor(named: "Dark Gray") ?? .darkGray }
    
    static var customBackground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .customDark
            } else {
                return .customLight
            }
        }
    }
    
    static var customText: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .customLight
            } else {
                return .customDark
            }
        }
    }
    
    static var customSecondText: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .customLightGray
            } else {
                return .customDarkGray
            }
        }
    }
    
    static var customButtonBackground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .customLight
            } else {
                return .customDark
            }
        }
    }
    
    static var customButtonText: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .customDark
            } else {
                return .customLight
            }
        }
    }
}
