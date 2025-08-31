//
//  Localizer+Mock.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//


struct MockLocalizer: Localizer {
    let overrides: [String: String]

    var currentLangKey: String { return "en" }

    func localized(_ key: String) -> String {
        overrides[key] ?? "[\(key)]"
    }
}
