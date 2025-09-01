//
//  ErrorView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 01/09/2025.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let localizer: Localizer
    let padding: CGFloat
    let onTap: VoidFunc?


    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundColor(.orange)

            Text(localizer.localized("error"))
                .font(.headline)
                .fontWeight(.medium)

            Text(errorMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(localizer.localized("retry")) {
                onTap?()
//                Task {
//                    await vm.loadCategories()
//                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}



