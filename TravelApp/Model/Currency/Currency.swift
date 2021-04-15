//
//  Currency.swift
//  TravelApp
//
//  Created by Raphaël Payet on 09/04/2021.
//

import Foundation

struct Currency: Decodable {
    struct Rates: Decodable {
        let USD: Double
    }
    
    let success: Bool
    let base: String
    let rates: Rates
}

