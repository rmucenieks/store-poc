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
            let localizer = LocalizationHandler()
            let bannerItem = BannerItem.bannerDemoItem(localizer: localizer)
            let cartVM = CartViewModel(localizer: localizer)
            StoreView(vm: StoreViewModel(repository: UStoreRepository(localizer: localizer),
                                         imgRepository: UImageRepository(),
                                         bannerItem: bannerItem,
                                         langHandler: localizer), cartModelVM: cartVM)
                .preferredColorScheme(.none) // Allow system to choose light/dark mode
        }
    }
}
