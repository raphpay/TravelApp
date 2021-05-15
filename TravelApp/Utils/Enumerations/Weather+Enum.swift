//
//  WeatherEnumerations.swift
//  TravelApp
//
//  Created by Raphaël Payet on 15/05/2021.
//

import Foundation

enum TimePeriod {
    case day, hour, current
    
    var excludeOptions: String {
        switch self {
        case .current:
            return "daily,hourly,minutely,alerts"
        case .hour:
            return "minutely,alerts,daily,current"
        case .day:
            return "hourly,minutely,alerts,current"
        }
    }
}

enum City {
    case local, newYork
    
    var position: (latitude: Double, longitude: Double) {
        switch self {
        case .local:
            return (-21.1336, 55.4719)
        case .newYork:
            return (40.7143, -74.006)
        }
    }
}

enum WeatherRange {
    case thunderstorm, drizzle, rain, snow, smoke, fog, clear, cloud
    
    var range: ClosedRange<Int> {
        switch self {
        case .thunderstorm:
            return 200...232
        case .drizzle:
            return 300...321
        case .rain:
            return 500...531
        case .snow:
            return 600...622
        case .smoke:
            return 711...711
        case .fog:
            return 741...741
        case .clear:
            return 800...800
        case .cloud:
            return 801...804
        }
    }
}
