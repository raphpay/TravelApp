//
//  Weather.swift
//  TravelApp
//
//  Created by Raphaël Payet on 12/04/2021.
//

import Foundation



// MARK: - UI Objects
struct WeatherCardObject {
    let date: String
    let temperature: Double
    let iconId: Int
}

// MARK: - Top layers
struct CurrentWeather: Decodable {
    let current : CurrentInfo
}

struct DailyWeather: Decodable {
    let daily: [DailyInfo]
}

struct HourlyWeather: Decodable {
    let hourly: [HourlyInfo]
}

// MARK: - Second Layers
struct CurrentInfo: Decodable {
    let temp: Double
    let weather: [WeatherInfo]
}

struct DailyInfo: Decodable {
    let dt: Double
    let temp: TempInfo
    let weather: [WeatherInfo]
}

struct HourlyInfo : Decodable {
    let dt: Double
    let temp: Double
    let weather: [WeatherInfo]
}


// MARK: - Third Layers
struct WeatherInfo: Decodable {
    let id: Int
}

struct TempInfo: Decodable {
    let day: Double
}
