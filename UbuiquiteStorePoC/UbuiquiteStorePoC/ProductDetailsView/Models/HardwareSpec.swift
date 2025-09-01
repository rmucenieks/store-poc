//
//  HardwareSpec.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 01/09/2025.
//

struct HardwareSpec: Decodable {
    struct Dimensions: Decodable {
        let millimeters: String
        let inches: String
    }

    struct Weight: Decodable {
        let kilograms: Double
        let pounds: Int
    }

    struct OperatingFrequency: Decodable {
        let us_ca: [String]
        let worldwide: [String]
    }

    struct AmbientOperatingTemperature: Decodable {
        let celsius: String
        let fahrenheit: String
    }

    let dimensions: Dimensions?
    let weight: Weight
    let maxPowerConsumption: String
    let voltageRange: String
    let networkingInterfaces: [String]
    let enclosureMaterial: [String]
    let mountMaterial: [String]
    let leds: [String]
    let systemBus: String
    let channelBandwidth: [String]
    let ndaaCompliant: Bool
    let certifications: [String]
    let operatingFrequency: OperatingFrequency?
    let ambientOperatingTemperature: AmbientOperatingTemperature?
}
