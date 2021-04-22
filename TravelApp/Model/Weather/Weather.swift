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
    let timezone: String
    let current : CurrentInfo
}

struct DailyWeather: Decodable {
    let timezone: String
    let daily: [DailyInfo]
}

struct HourlyWeather: Decodable {
    let timezone: String
    let hourly: [HourlyInfo]
}

// MARK: - Second Layers
struct CurrentInfo: Decodable {
    let dt: Double
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

let HOURLY_WEATHER_JSON = """
{
  "timezone": "Etc/GMT+1",
  "hourly": [
    {
      "dt": 1618657200,
      "weather": [
        {
          "id": 804,
        }
      ]
    }
  ]
}
"""

let CURRENT_WEATHER_JSON = """
{
  "timezone": "Etc/GMT+1",
  "current": {
    "dt": 1618661258,
    "weather": [
      {
        "id": 804,
      }
    ]
  }
}
"""

let DAILY_WEATHER_JSON = """
{
  "timezone": "Etc/GMT+1",
  "daily": [
    {
      "dt": 1618664400,
      "temp": {
        "day": 282.67,
      },
      "weather": [
        {
          "id": 501
        }
      ]
    }
  ]
}
"""
