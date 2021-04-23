
//  WeatherService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 12/04/2021.
//

import UIKit


// MARK: - Enumerations
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

class WeatherService {
    
    // MARK: - Properties
    static var shared = WeatherService()
    private init() {}
    private let API_KEY = "d92d5ad479ad8dc13ee9cd7c4739939d"
    
    private let baseStringURL = "https://api.openweathermap.org/data/2.5/onecall?"
    
    private var latitude: Double = 0
    private var longitude: Double = 0
    private var excludeOptions: String = ""
    private var array = [WeatherCardObject]()
    
    // MARK: - Public functions
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
    
    
    // MARK: - Decoding Methods
    private func decodeDailyWeather(data: Data?, completion: @escaping ((_ success: Bool, _ weatherObjects: [WeatherCardObject]?) -> Void)) {
        guard let data = data,
                let responseJSON = try? JSONDecoder().decode(DailyWeather.self, from: data) else {
            completion(false, nil)
            return
        }
        
        for day in responseJSON.daily {
            let displayableDate = format(date: NSDate(timeIntervalSince1970: day.dt), to: "E")
            let kelvinTemperature = day.temp.day
            let temperature = kelvinTemperature.convertFromKelvinToCelsius().round(to: 0)
            let weatherID = day.weather[0].id
            let weatherObject = WeatherCardObject(date: displayableDate,
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
        
        for item in 0..<7 {
            let hour = responseJSON.hourly[item]
            let displayableDate = format(date: NSDate(timeIntervalSince1970: hour.dt), to: "HH")
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
    
    
    // MARK: - Conversion Methods
    private func format(date: NSDate, to stringFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        return formatter.string(from: date as Date)
    }
    
    func convertIcon(id: Int) -> UIImage {
        var icon = UIImage()
        
        if WeatherRange.thunderstorm.range.contains(id) {
            icon = UIImage(named: WeatherIcons.thunderstorm.rawValue)!
        } else if WeatherRange.drizzle.range.contains(id) {
            icon = UIImage(named: WeatherIcons.drizzle.rawValue)!
        } else if WeatherRange.rain.range.contains(id) {
            icon = UIImage(named: WeatherIcons.rain.rawValue)!
        } else if WeatherRange.snow.range.contains(id) {
            icon = UIImage(named: WeatherIcons.snow.rawValue)!
        } else if WeatherRange.smoke.range.contains(id) {
            icon = UIImage(named: WeatherIcons.smoke.rawValue)!
        } else if WeatherRange.fog.range.contains(id) {
            icon = UIImage(named: WeatherIcons.fog.rawValue)!
        } else if WeatherRange.clear.range.contains(id) {
            icon = UIImage(named: WeatherIcons.clear.rawValue)!
        } else if WeatherRange.cloud.range.contains(id) {
            icon = UIImage(named: WeatherIcons.cloud.rawValue)!
        } else {
            icon = UIImage(named: WeatherIcons.clear.rawValue)!
        }
        
        return icon
    }
}
