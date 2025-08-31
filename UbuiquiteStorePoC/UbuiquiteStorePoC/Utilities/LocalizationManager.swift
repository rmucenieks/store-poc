import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
            UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            // Force UI update by posting notification
            NotificationCenter.default.post(name: .languageChanged, object: nil)
            
            // Debug print to verify language change
            print("🌍 Language changed to: \(currentLanguage.displayName) (\(currentLanguage.rawValue))")
        }
    }
    
    enum Language: String, CaseIterable {
        case english = "en"
        case latvian = "lv"
        case russian = "ru"
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .latvian: return "Latviešu"
            case .russian: return "Русский"
            }
        }
        
        var flag: String {
            switch self {
            case .english: return "🇺🇸"
            case .latvian: return "🇱🇻"
            case .russian: return "🇷🇺"
            }
        }
    }
    
    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Language.english.rawValue
        self.currentLanguage = Language(rawValue: savedLanguage) ?? .english
    }
    
    func localizedString(for key: String) -> String {
        let bundle = Bundle.main
        let language = currentLanguage.rawValue
        
        if let path = bundle.path(forResource: language, ofType: "lproj"),
           let languageBundle = Bundle(path: path) {
            let localizedString = languageBundle.localizedString(forKey: key, value: key, table: "Localizable")
            print("🌐 [\(language)] '\(key)' -> '\(localizedString)'")
            return localizedString
        }
        
        print("⚠️ [\(language)] Bundle not found for language, using fallback for key: '\(key)'")
        return bundle.localizedString(forKey: key, value: key, table: "Localizable")
    }
    
    func resetToDefaultLanguage() {
        currentLanguage = .english
        UserDefaults.standard.removeObject(forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
        print("🔄 Reset to default language: English")
    }
    
    func getCurrentLanguageInfo() -> String {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "none"
        let appleLanguages = UserDefaults.standard.array(forKey: "AppleLanguages") as? [String] ?? []
        return """
        🌍 Current Language Info:
        - Selected: \(currentLanguage.displayName) (\(currentLanguage.rawValue))
        - Saved in UserDefaults: \(savedLanguage)
        - AppleLanguages: \(appleLanguages)
        - Bundle languages: \(Bundle.main.localizations)
        """
    }
}

// MARK: - Localized String Extension
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
