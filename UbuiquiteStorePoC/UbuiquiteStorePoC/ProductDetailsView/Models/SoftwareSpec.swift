//
//  SoftwareSpec.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 01/09/2025.
//

struct SoftwareSpec: Decodable {
    struct MobileApp: Decodable {
        let ios: String
        let android: String
    }

    let unifiNetwork: String
    let mobileApp: MobileApp?
}
