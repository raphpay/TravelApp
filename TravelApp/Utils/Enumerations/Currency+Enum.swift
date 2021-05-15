//
//  Currency+Enum.swift
//  TravelApp
//
//  Created by Raphaël Payet on 15/05/2021.
//

import Foundation

enum CurrencyType {
    case euro
    case usDollar

    var info: (code: String, symbol: String) {
        switch self {
        case .euro:
            return ("EUR", "€")
        case .usDollar:
            return ("USD", "$")
        }
    }
}
