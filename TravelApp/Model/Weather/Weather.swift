//
//  Weather.swift
//  TravelApp
//
//  Created by Raphaël Payet on 12/04/2021.
//

import Foundation

struct Weather : Decodable {
    let timezone: String
    let current: CurrentWeather
}

struct CurrentWeather: Decodable {
    let dt: Double
    let weather: [WeatherData]
}

struct WeatherData: Decodable {
    let id: Double
}
