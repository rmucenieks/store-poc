import SwiftUI

//struct LocalizationTestView: View {
//    @ObservedObject private var localizationManager = LocalizationManager.shared
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    // Language Info
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Current Language: \(localizationManager.currentLanguage.displayName)")
//                            .font(.headline)
//                        Text("Language Code: \(localizationManager.currentLanguage.rawValue)")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding()
//                    .background(Color.blue.opacity(0.1))
//                    .cornerRadius(12)
//                    
//                    // Test Localized Strings
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text("Localization Test")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                        
//                        Group {
//                            LocalizedStringRow(key: "loading_categories", label: "Loading Categories")
//                            LocalizedStringRow(key: "error", label: "Error")
//                            LocalizedStringRow(key: "retry", label: "Retry")
//                            LocalizedStringRow(key: "categories", label: "Categories")
//                            LocalizedStringRow(key: "products", label: "Products")
//                            LocalizedStringRow(key: "add_to_cart", label: "Add to Cart")
//                            LocalizedStringRow(key: "description", label: "Description")
//                            LocalizedStringRow(key: "specifications", label: "Specifications")
//                        }
//                    }
//                    .padding()
//                    .background(Color.green.opacity(0.1))
//                    .cornerRadius(12)
//                    
//                    // Language Switcher
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Language Options")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                        
//                        ForEach(LocalizationManager.Language.allCases, id: \.self) { language in
//                            Button(action: {
//                                localizationManager.currentLanguage = language
//                            }) {
//                                HStack {
//                                    Text(language.flag)
//                                        .font(.title2)
//                                    Text(language.displayName)
//                                        .foregroundColor(.primary)
//                                    Spacer()
//                                    if localizationManager.currentLanguage == language {
//                                        Image(systemName: "checkmark.circle.fill")
//                                            .foregroundColor(.green)
//                                    }
//                                }
//                                .padding()
//                                .background(localizationManager.currentLanguage == language ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
//                                .cornerRadius(8)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                    }
//                    .padding()
//                    .background(Color.orange.opacity(0.1))
//                    .cornerRadius(12)
//                    
//                    // Debug Info
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Debug Information")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                        
//                        Text(localizationManager.getCurrentLanguageInfo())
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                            .padding()
//                            .background(Color.red.opacity(0.1))
//                            .cornerRadius(8)
//                    }
//                    .padding()
//                    .background(Color.red.opacity(0.05))
//                    .cornerRadius(12)
//                }
//                .padding()
//            }
//            .navigationTitle("Localization Test")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//struct LocalizedStringRow: View {
//    let key: String
//    let label: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(label)
//                .font(.caption)
//                .foregroundColor(.secondary)
//            Text(key.localized)
//                .font(.body)
//                .fontWeight(.medium)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.vertical, 4)
//    }
//}
//
//#Preview {
//    LocalizationTestView()
//}
