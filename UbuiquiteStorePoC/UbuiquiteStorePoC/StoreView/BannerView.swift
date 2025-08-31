//
//  BannerView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

import SwiftUI

struct BannerView: View {

    let bannerItem: BannerItem
    let storeURL: URL?

    var body: some View {
        Button(action: {
            if let url = storeURL {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(bannerItem.introText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(bannerItem.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(bannerItem.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Placeholder for U7 Pro image
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text(bannerItem.initials)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    )
            }
            .padding(20)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(BannerButtonStyle())
    }
}

struct BannerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    let localizer =  MockLocalizer(overrides: [:])

    let bannerItem = BannerItem.bannerDemoItem(localizer: localizer)
    BannerView(bannerItem: bannerItem, storeURL: nil)
}
