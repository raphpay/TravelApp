//
//  Weather.swift
//  TravelApp
//
//  Created by Raphaël Payet on 12/04/2021.
//

import Foundation

struct Weather : Decodable {
    let currentWeather: CurrentWeather
}

struct CurrentWeather: Decodable {
    let date: Double
    let temperature: Double
    let weatherData: WeatherData
}

struct WeatherData: Decodable {
    let id: Int
}
