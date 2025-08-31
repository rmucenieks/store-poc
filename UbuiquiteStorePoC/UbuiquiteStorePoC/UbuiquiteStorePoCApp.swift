//
//  UbuiquiteStorePoCApp.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import SwiftUI

@main
struct UbuiquiteStorePoCApp: App {
    var body: some Scene {
        WindowGroup {
            StoreView(vm: StoreViewModel(repository: UStoreRepository(),
                                         imgRepository: UImageRepository(),
                                         bannerItem: BannerItem.bannerDemoItem))
                .preferredColorScheme(.none) // Allow system to choose light/dark mode
        }
    }
}
