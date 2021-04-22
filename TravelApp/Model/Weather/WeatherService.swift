
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

class WeatherService {
    static var shared = WeatherService()
    private init() {}
    private let API_KEY = "d92d5ad479ad8dc13ee9cd7c4739939d"
    
    private let baseStringURL = "https://api.openweathermap.org/data/2.5/onecall?"
    
    private var latitude: Double = 0
    private var longitude: Double = 0
    private var excludeOptions: String = ""
    
    func getDailyWeather(in city: City, completion: @escaping ((_ weatherObject: [WeatherCardObject]) -> Void)) {
        // TODO : Find a way to make the switch inside the enum, or not in here
        switch city {
            case .local:
                latitude = 55.4719
                longitude = -21.1336
            case .newYork:
                latitude = 40.7143
                longitude = -74.006
        }
        let excludeOptions = "hourly,minutely,alerts,current"
        let completeStringURL = baseStringURL + "appid=" + API_KEY + "&lat=\(latitude)" + "&lon=\(longitude)" + "&exclude=\(excludeOptions)"
        let url = URL(string: completeStringURL)!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        var array: [WeatherCardObject] = []
        let task = session.dataTask(with: request) { _data, _response, _error in
            DispatchQueue.main.async {
                guard _error == nil else { return }
                guard let data = _data else { return }
                guard let response = _response as? HTTPURLResponse,
                      response.statusCode == 200 else { return }
                guard let responseJSON = try? JSONDecoder().decode(DailyWeather.self, from: data) else {
                    print("not correct")
                    return
                }
    //            print(responseJSON)
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
                completion(array)
            }
        }
        task.resume()
    }
    func getHourlyWeather(in city: City, completion: @escaping ((_ weatherID: Int, _ temperature: Double) -> Void)) {
        switch city {
            case .local:
                latitude = 55.4719
                longitude = -21.1336
            case .newYork:
                latitude = 40.7143
                longitude = -74.006
        }
        let excludeOptions = "minutely,alerts,daily,current"
        let completeStringURL = baseStringURL + "appid=" + API_KEY + "&lat=\(latitude)" + "&lon=\(longitude)" + "&exclude=\(excludeOptions)"
        let url = URL(string: completeStringURL)!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { _data, _response, _error in
            guard _error == nil else { return }
            guard let data = _data else { return }
            guard let response = _response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            guard let responseJSON = try? JSONDecoder().decode(HourlyWeather.self, from: data) else {
                print("not correct")
                return
            }
            
            print(responseJSON.hourly[0].dt)
            
            let date = NSDate(timeIntervalSince1970: responseJSON.hourly[1].dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            print(formatter.string(from: date as Date))
        }
        task.resume()
    }
    func getCurrentWeather(in city: City, completion: @escaping ((_ weatherID: Int, _ temperature: Double) -> Void)) {
        // Step 1 : Create the URL
        switch city {
            case .local:
                latitude = -21.13357
                longitude = 55.4719
            case .newYork:
                latitude = 40.7143
                longitude = -74.006
        }
        
        let excludeOptions = "daily,hourly,minutely,alerts"
        let completeStringURL = baseStringURL + "appid=" + API_KEY + "&lat=\(latitude)" + "&lon=\(longitude)" + "&exclude=\(excludeOptions)"
        let url = URL(string: completeStringURL)!
        // Step 2 : Create the request
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { _data, _response, _error in
            // Step 3: Verify the data
            guard _error == nil else { return }
            guard let data = _data else { return }
            guard let response = _response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            guard let responseJSON = try? JSONDecoder().decode(CurrentWeather.self, from: data) else {
                print("not correct")
                return
            }
            // Step 4 : Use the data
            let weatherID = responseJSON.current.weather[0].id
            let temperatureInKelvin = responseJSON.current.temp
            // TODO : Get a rounded Int
            let convertedTemperature = temperatureInKelvin.convertFromKelvinToCelsius().round(to: 0)
            print(convertedTemperature)
            DispatchQueue.main.async {
                completion(weatherID, convertedTemperature)
            }
        }
        task.resume()
    }
}
