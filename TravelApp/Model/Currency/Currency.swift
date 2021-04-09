//
//  Currency.swift
//  TravelApp
//
//  Created by Raphaël Payet on 09/04/2021.
//

import Foundation

struct Currency: Decodable {
    let base: String
    let rates: [Rate]
}

struct Rate: Decodable {
    let base: String
    let value: Double
}
