//
//  Currency.swift
//  TravelApp
//
//  Created by Raphaël Payet on 09/04/2021.
//

import Foundation

class Currency {
    let base: CurrencyType
    let value: Int? = 0
    
    init(base: CurrencyType) {
        self.base = base
    }
}
