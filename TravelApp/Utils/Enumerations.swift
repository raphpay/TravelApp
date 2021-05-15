//
//  Enumerations.swift
//  TravelApp
//
//  Created by Raphaël Payet on 15/05/2021.
//

import Foundation

enum ErrorMessages: String {
    case currency = "Can't retrieve rate informations. \nPlease try again later."
    case currencyWrongEntry = "Can't convert this entry into a number. \nPlease enter numbers instead."
    case translate = "Can't translate text.\nPlease try again later."
    case weather = "Can't retrieve weather informations.\nPlease try again later."
}
