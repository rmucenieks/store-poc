//
//  BannerItem.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

struct BannerItem: Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let introText: String
    let initials: String

    static var bannerDemoItem: BannerItem {
        return BannerItem(id: "u7",
                          name: "UniFi U7 Pro",
                          subtitle: "wifi_7_high_performance".localized,
                          introText: "introducing".localized,
                          initials: "U7")
    }
}
