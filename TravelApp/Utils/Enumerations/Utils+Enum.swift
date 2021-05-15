//
//  Enumerations.swift
//  TravelApp
//
//  Created by Raphaël Payet on 15/05/2021.
//

import Foundation


enum Alert: String {
    case currency, currencyWrongEntry, translate, translateWrongEntry, currentWeather, dailyWeather, hourlyWeather
    
    var message : String {
        switch self {
        case .currency:
            return "Can't retrieve rate informations. \nPlease try again later."
        case .currencyWrongEntry:
            return "Can't convert this entry into a number. \nPlease enter numbers instead."
        case .translate:
            return "Can't translate text.\nPlease try again later."
        case .translateWrongEntry:
            return "Can't translate this entry.\nPlease enter a text instead."
        case .currentWeather:
            return "Unable to load current weather. \nPlease try again later"
        case .hourlyWeather:
            return "Unable to load hourly weather. \nPlease try again later"
        case .dailyWeather:
            return "Unable to load daily weather. \nPlease try again later"
        }
    }
}
