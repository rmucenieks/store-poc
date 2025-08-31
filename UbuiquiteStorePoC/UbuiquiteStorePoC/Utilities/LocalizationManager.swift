import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
            UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
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
            return languageBundle.localizedString(forKey: key, value: key, table: "Localizable")
        }
        
        return bundle.localizedString(forKey: key, value: key, table: "Localizable")
    }
}

// MARK: - Localized String Extension
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
}
