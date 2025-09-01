import SwiftUI

struct LanguageSwitcherView: View {
    @ObservedObject private var localization: LocalizationHandler
    @Environment(\.dismiss) private var dismiss


    init(localization: LocalizationHandler) {
        self.localization = localization
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(localization.allAppLanguages, id: \.self) { language in
                    Button(action: {
                        localization.currentLanguage = language
                        dismiss()
                    }) {
                        HStack {
                            Text(language.flag)
                                .font(.title2)

                            Text(language.displayName)
                                .foregroundColor(.primary)

                            Spacer()

                            if localization.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                }
            }
            .navigationTitle(localization.localized("Language"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localization.localized("close")) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let handler = LocalizationHandler(language: .english)
    LanguageSwitcherView(localization: handler)
}
