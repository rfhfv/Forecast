import UIKit

final class ThemeManager {
    static let shared = ThemeManager()
    private let userDefaults = UserDefaults.standard
    private let themeKey = "app_theme"
    
    var currentTheme: Theme {
        let savedTheme = userDefaults.string(forKey: themeKey) ?? "light"
        return Theme(rawValue: savedTheme) ?? .light
    }
    
    private init() {
        applyTheme(currentTheme)
    }
    
    func applyTheme(_ theme: Theme) {
        userDefaults.set(theme.rawValue, forKey: themeKey)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        switch theme {
        case .light: window.overrideUserInterfaceStyle = .light
        case .dark: window.overrideUserInterfaceStyle = .dark
        }
    }
    
    func toggleTheme() {
        let newTheme: Theme = currentTheme == .light ? .dark : .light
        applyTheme(newTheme)
    }
    
    func iconName(for theme: Theme) -> String {
        theme == .light ? Constants.Image.Name.sun : Constants.Image.Name.moon
    }
}
