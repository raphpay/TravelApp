//
//  WeatherService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 12/04/2021.
//

import Foundation

//let FIXER_IO_ACCESS_KEY = "35a65c4c0c6a14b719046795b7a5f816"

class WeatherService {
    static var shared = WeatherService()
    private init() {}
    
    private let baseURL = "http://data.fixer.io/api/latest?access_key="
    
    func getRate(from base: CurrencyType, to rate: CurrencyType) {
        let url = URL(string: "")!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { _data, _response, _error in
            guard _error == nil else { return }
            guard let data = _data else { return }
            guard let response = _response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            // Decode data now
        }
        task.resume()
    }
    
}
