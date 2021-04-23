
//  WeatherService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 12/04/2021.
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
    
    var latitude: Double{
        switch self {
        case .local:
            return -21.1336
        case .newYork:
            return 40.7143
        }
    }
    
    var longitude: Double{
        switch self {
        case .local:
            return 55.4719
        case .newYork:
            return -74.006
        }
    }
}


//exempleCall = "https://api.openweathermap.org/data/2.5/onecall?appid=d92d5ad479ad8dc13ee9cd7c4739939d&lat=40.7143&lon=-74.006&exclude=hourly,minutely,alerts,daily"

class WeatherService {
    static var shared = WeatherService()
    private init() {}
    private let API_KEY = "d92d5ad479ad8dc13ee9cd7c4739939d"
    
    private let baseStringURL = "https://api.openweathermap.org/data/2.5/onecall?"
    
    private var latitude: Double = 0
    private var longitude: Double = 0
    private var excludeOptions: String = ""
    private var array = [WeatherCardObject]()
    
    // TODO : Create a function to format date
    
    func getWeather(in city: City, for period: TimePeriod, completion: @escaping ((_ success: Bool, _ weatherObject: [WeatherCardObject]?) -> Void)) {
        let completeStringURL = baseStringURL + "appid=" + API_KEY + "&lat=\(city.latitude)" + "&lon=\(city.longitude)" + "&exclude=\(period.excludeOptions)"
        let url = URL(string: completeStringURL)!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { _data, _response, _error in
            DispatchQueue.main.async {
                guard _error == nil else {
                    completion(false, nil)
                    return
                }
                guard let data = _data else {
                    completion(false, nil)
                    return
                }
                guard let response = _response as? HTTPURLResponse,
                      response.statusCode == 200 else { return }
                
                switch period {
                    case .current:
                        self.decodeCurrentWeather(data: data) { (success, objects) in
                            completion(success, objects)
                        }
                    case .day:
                        self.decodeDailyWeather(data: data) { (success, objects) in
                            completion(success, objects)
                        }
                    case .hour:
                        self.decodeHourlyWeather(data: data) { (success, objects) in
                            completion(success, objects)
                        }
                }
            }
        }
        task.resume()
    }
    
    private func decodeDailyWeather(data: Data?, completion: @escaping ((_ success: Bool, _ weatherObjects: [WeatherCardObject]?) -> Void)) {
        guard let data = data,
                let responseJSON = try? JSONDecoder().decode(DailyWeather.self, from: data) else {
            completion(false, nil)
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        for day in responseJSON.daily {
            let dayDate = NSDate(timeIntervalSince1970: day.dt)
            let currentDate = formatter.string(from: dayDate as Date)
            let kelvinTemperature = day.temp.day
            let temperature = kelvinTemperature.convertFromKelvinToCelsius().round(to: 0)
            let weatherID = day.weather[0].id
            let weatherObject = WeatherCardObject(date: currentDate,
                                                  temperature: temperature,
                                                  iconId: weatherID)
            array.append(weatherObject)
        }
        // Remove the first day of the array cause it's yesterday
        array.remove(at: 0)
        completion(true, array)
    }
    
    private func decodeHourlyWeather(data: Data?, completion: @escaping((_ success: Bool, _ weatherObjects: [WeatherCardObject]?) -> Void)) {
        guard let data = data,
              let responseJSON = try? JSONDecoder().decode(HourlyWeather.self, from: data) else {
            completion(false, nil)
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        
        for item in 0..<7 {
            let hour = responseJSON.hourly[item]
            let hourDate = NSDate(timeIntervalSince1970: hour.dt)
            let displayableDate = formatter.string(from: hourDate as Date)
            let kelvinTemperature = hour.temp
            let displayableTemp = kelvinTemperature.convertFromKelvinToCelsius().round(to: 0)
            let weatherID = hour.weather[0].id
            
            let object = WeatherCardObject(date: displayableDate, temperature: displayableTemp, iconId: weatherID)
            array.append(object)
        }
        completion(true, array)
    }
    
    private func decodeCurrentWeather(data: Data?, completion: @escaping((_ success: Bool, _ weatherObjects: [WeatherCardObject]?) -> Void)) {
        guard let data = data,
              let responseJSON = try? JSONDecoder().decode(CurrentWeather.self, from: data) else {
            completion(false, nil)
            return
        }
        let weatherID = responseJSON.current.weather[0].id
        let temperatureInKelvin = responseJSON.current.temp
        // TODO : Get a rounded Int
        let convertedTemperature = temperatureInKelvin.convertFromKelvinToCelsius().round(to: 0)
        let object = [WeatherCardObject(date: "", temperature: convertedTemperature, iconId: weatherID)]
        completion(true, object)
    }
}
