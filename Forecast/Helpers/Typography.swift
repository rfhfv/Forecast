import UIKit

enum Typography {
    case microscopic, tiny, small, medium, large, huge
    
    var font: UIFont {
        switch self {
        case .microscopic: return UIFont.systemFont(ofSize: 12, weight: .regular)
        case .tiny: return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .small: return UIFont.systemFont(ofSize: 18, weight: .heavy)
        case .medium: return UIFont.systemFont(ofSize: 22, weight: .heavy)
        case .large: return UIFont.systemFont(ofSize: 24, weight: .heavy)
        case .huge: return UIFont.systemFont(ofSize: 200, weight: .heavy)
        }
    }
}
