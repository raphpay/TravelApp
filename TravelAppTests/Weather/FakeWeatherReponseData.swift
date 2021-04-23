//
//  FakeWeatherReponseData.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 23/04/2021.
//

import Foundation

class FakeWeatherResponseData {
    
    static var currentWeatherCorrectData: Data {
        let bundle = Bundle(for: FakeWeatherResponseData.self)
        let url = bundle.url(forResource: "CurrentWeather", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static var dailyWeatherCorrectData: Data {
        let bundle = Bundle(for: FakeWeatherResponseData.self)
        let url = bundle.url(forResource: "DailyWeather", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static var hourlyWeatherCorrectData: Data {
        let bundle = Bundle(for: FakeWeatherResponseData.self)
        let url = bundle.url(forResource: "HourlyWeather", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://apple.com")!,
                                            statusCode: 200,
                                            httpVersion: nil, headerFields: nil)
    
    static let responseNotOK = HTTPURLResponse(url: URL(string: "https://apple.com")!,
                                            statusCode: 500,
                                            httpVersion: nil, headerFields: nil)
    // On simule le fait qu'il y a une erreur
    class WeatherError: Error {}
    static let error = WeatherError()
    
}
