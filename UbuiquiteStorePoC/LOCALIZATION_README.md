# Localization Implementation

This document describes the localization system implemented in the UniFi Store PoC app.

## Overview

The app now supports three languages:
- **English (EN)** - Default language
- **Latvian (LV)** - Latviešu
- **Russian (RU)** - Русский

## Implementation Details

### 1. LocalizationManager

The `LocalizationManager` class handles language switching and provides localized strings throughout the app.

**Key Features:**
- Singleton pattern for app-wide access
- Automatic language persistence using UserDefaults
- Support for dynamic language switching
- Integration with iOS system localization

**Usage:**
```swift
// Get localized string
let localizedText = "key_name".localized

// Switch language
LocalizationManager.shared.currentLanguage = .latvian
```

### 2. Localization Files

The app includes localization files for each supported language:

- `en.lproj/Localizable.strings` - English strings
- `lv.lproj/Localizable.strings` - Latvian strings  
- `ru.lproj/Localizable.strings` - Russian strings

### 3. Language Switcher

Users can change the app language by tapping the language button in the header (shows current language flag and code).

**Features:**
- Visual language selection with flags
- Current language indication with checkmark
- Immediate language switching without app restart

### 4. Localized Strings

All hardcoded strings have been replaced with localization keys:

**Store View:**
- Loading states
- Error messages
- Button labels
- Section headers

**Product Details:**
- Field labels
- Button text
- Section titles

**Common Elements:**
- Navigation titles
- Alert messages
- Placeholder text

## Adding New Localized Strings

### 1. Add the key to all language files:

**English (en.lproj/Localizable.strings):**
```
"new_key" = "English text";
```

**Latvian (lv.lproj/Localizable.strings):**
```
"new_key" = "Latviešu teksts";
```

**Russian (ru.lproj/Localizable.strings):**
```
"new_key" = "Русский текст";
```

### 2. Use in code:
```swift
Text("new_key".localized)
```

## Supported Languages

### English (EN)
- Default language
- Fallback for missing translations
- Used in development and testing

### Latvian (LV)
- Full translation of all UI elements
- Proper Latvian grammar and terminology
- Cultural adaptation for Latvian users

### Russian (RU)
- Complete Russian localization
- Cyrillic script support
- Russian-specific terminology

## Technical Implementation

### String Extension
The app uses a String extension for easy localization:
```swift
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
}
```

### Language Persistence
- Language selection is saved to UserDefaults
- App remembers user's language preference
- Language persists across app launches

### Dynamic Updates
- UI updates immediately when language changes
- No app restart required
- Smooth user experience

## Testing Localization

### 1. Language Switching
- Use the language switcher in the app header
- Verify all strings update correctly
- Check for proper text layout in different languages

### 2. Edge Cases
- Test with very long text in different languages
- Verify proper text wrapping
- Check for missing translations

### 3. Accessibility
- Ensure VoiceOver works with all languages
- Test Dynamic Type with different languages
- Verify proper text scaling

## Future Enhancements

### Potential Improvements:
- Add more languages (German, French, Spanish)
- Implement RTL language support
- Add language-specific formatting (dates, numbers)
- Implement server-side localization for dynamic content

### Considerations:
- Maintain consistent terminology across languages
- Regular updates for new features
- Community translation contributions
- Localization quality assurance

## Troubleshooting

### Common Issues:
1. **Missing translations**: Check if the key exists in all language files
2. **Layout issues**: Verify text fits properly in different languages
3. **Language not persisting**: Check UserDefaults implementation
4. **Performance**: Monitor memory usage with multiple language bundles

### Debug Tips:
- Use Xcode's localization debugging tools
- Check console for missing key warnings
- Verify bundle structure and file naming
- Test on different device orientations and sizes
