//
//  WeatherService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 12/04/2021.
//

import Foundation

enum TimePeriod {
    case week, day, current
}

enum City {
    case local, newYork
}

//exempleCall = "https://api.openweathermap.org/data/2.5/onecall?appid=d92d5ad479ad8dc13ee9cd7c4739939d&lat=40.7143&lon=-74.006&exclude=hourly,minutely,alerts,daily"

let WEATHER_JSON = """
{
  "lat": 33.4418,
  "lon": -94.0377,
  "timezone": "America/Chicago",
  "timezone_offset": -18000,
  "current": {
    "date": 1617944249,
    "weather": [
      {
        "id": 800
      }
    ]
  }
}
"""

class WeatherService {
    static var shared = WeatherService()
    private init() {}
    private let API_KEY = "d92d5ad479ad8dc13ee9cd7c4739939d"
    
    private let baseStringURL = "https://api.openweathermap.org/data/2.5/onecall?"
    
    private var latitude: Double = 0
    private var longitude: Double = 0
    private var excludeOptions: String = ""
    
    
    
    func getWeather(in city: City, for timePeriod: TimePeriod) {
        // TODO : Find a way to make the switch inside the enum, or not in here
        switch city {
            case .local:
                latitude = 55.4719
                longitude = -21.1336
            case .newYork:
                latitude = 40.7143
                longitude = -74.006
        }
        switch timePeriod {
        case .week:
            // Used for weekly periods
            excludeOptions = "hourly,minutely,alerts,current"
        case .day:
            // Used for weather hour after hour in a day
            excludeOptions = "minutely,alerts,daily,current"
        case .current:
            // Used for current weather on big icon
            excludeOptions = "daily,hourly,minutely,alerts"
        }

        let completeStringURL = baseStringURL + "appid=" + API_KEY + "&lat=\(latitude)" + "&lon=\(longitude)" + "&exclude=\(excludeOptions)"
        let url = URL(string: completeStringURL)!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { _data, _response, _error in
            guard _error == nil else { return }
            guard let data = _data else { return }
            guard let response = _response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            guard let responseJSON = try? JSONDecoder().decode(Weather.self, from: data) else {
                print("not correct")
                return
            }
            
//            let jsonData = WEATHER_JSON.data(using: .utf8)!
//            print(jsonData)
//            guard let responseJSON = try? JSONDecoder().decode(Weather.self, from: jsonData) else {
//                print("not correct")
//                return
//            }
            
            print(responseJSON.timezone)
            print(responseJSON.current)
        }
        task.resume()
    }
    
}
