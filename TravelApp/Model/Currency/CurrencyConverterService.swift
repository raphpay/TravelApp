//
//  CurrencyConverterService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 09/04/2021.
//

import Foundation

let FIXER_IO_ACCESS_KEY = "35a65c4c0c6a14b719046795b7a5f816"

class CurrencyConverterService {
    static var shared = CurrencyConverterService()
    private init() {}
    
    private let baseURL = "http://data.fixer.io/api/latest?access_key="
    
    func getRate(from base: CurrencyType, to rate: CurrencyType) {
        let completeEndPoint = "\(baseURL)\(FIXER_IO_ACCESS_KEY)&base=\(base.rawValue)&symbols=\(rate.rawValue)"
        let completeURL = URL(string: completeEndPoint)!
        let request = URLRequest(url: completeURL)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { _data, _response, _error in
            print(_data)
            print(_response)
            print(_error)
        }
        task.resume()
    }
}