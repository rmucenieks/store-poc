//
//  OverViewSpec.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 01/09/2025.
//

struct OverViewSpec: Decodable {
    struct CoverageArea: Decodable {
        let squareMeters: Int
        let squareFeet: Int
    }

    let streams: Int
    let coverageArea: CoverageArea?
    let maxClientCount: String
    let uplink: String
    let mounting: [String]
    let powerMethod: String
    let frequency: String
}
