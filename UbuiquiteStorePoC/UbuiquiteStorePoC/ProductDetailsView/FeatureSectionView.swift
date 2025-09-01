//
//  FeatureSectionView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 01/09/2025.
//

import SwiftUI

struct FeatureSectionView: View {
    let title: String
    let features: [String]

    var body: some View {
        VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                }

                ForEach(features, id: \.self) { feature in
                    Label(feature, systemImage: "checkmark.circle")
                        .foregroundColor(.secondary)
                        .padding(.vertical, 2)
                }
        }
        .padding(.vertical)
    }
}
