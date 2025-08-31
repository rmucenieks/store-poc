# Localization Testing Guide

## Quick Test Steps

### 1. Build and Run
1. Clean build folder (Cmd+Shift+K)
2. Build project (Cmd+B)
3. Run on simulator or device

### 2. Verify Default Language
- App should start in English by default
- Check console for: `🌍 Language changed to: English (en)`

### 3. Test Language Switching
1. Tap the language button in the header (shows 🇺🇸 EN)
2. Select a different language (e.g., Latvian)
3. Check console for: `🌍 Language changed to: Latviešu (lv)`
4. Verify UI text changes to the selected language

### 4. Use Debug Tools
- **Info Button (ℹ️)**: Tap to print current language info to console
- **ABC Button (🔤)**: Opens localization test view
- **Reset Button**: In language switcher, resets to English

## Expected Console Output

### When App Starts:
```
🌍 Language changed to: English (en)
🌐 [en] 'loading_categories' -> 'Loading categories...'
🌐 [en] 'error' -> 'Error'
```

### When Switching to Latvian:
```
🌍 Language changed to: Latviešu (lv)
🌐 [lv] 'loading_categories' -> 'Ielādē kategorijas...'
🌐 [lv] 'error' -> 'Kļūda'
```

### When Switching to Russian:
```
🌍 Language changed to: Русский (ru)
🌐 [ru] 'loading_categories' -> 'Загрузка категорий...'
🌐 [ru] 'error' -> 'Ошибка'
```

## Troubleshooting

### If Language Doesn't Change:
1. Check console for error messages
2. Verify `.lproj` folders are in Xcode project
3. Check that files are added to app target
4. Verify bundle structure

### If Strings Don't Localize:
1. Check console for `⚠️ Bundle not found` messages
2. Verify localization file names match language codes
3. Check that `Localizable.strings` files are properly formatted

### Common Issues:
- **Missing .lproj folders**: Add them to Xcode project
- **Wrong file names**: Must be `en.lproj`, `lv.lproj`, `ru.lproj`
- **Bundle not included**: Ensure files are added to app target
- **Syntax errors**: Check `.strings` file format

## Testing Checklist

- [ ] App starts in English
- [ ] Language switcher opens
- [ ] Switching to Latvian works
- [ ] Switching to Russian works
- [ ] UI text updates immediately
- [ ] Language persists after app restart
- [ ] Console shows proper debug info
- [ ] All strings are localized
- [ ] Reset button works
- [ ] Test view shows correct translations

## Debug Information

The app includes several debug features:
1. **Console logging** for all language changes
2. **Bundle verification** for localization files
3. **Language info display** in test view
4. **Reset functionality** for testing
5. **Visual indicators** for current language

## Next Steps

Once localization is working:
1. Test on different devices/simulators
2. Verify all UI elements are translated
3. Test edge cases (very long text, special characters)
4. Consider adding more languages
5. Implement server-side localization for dynamic content
