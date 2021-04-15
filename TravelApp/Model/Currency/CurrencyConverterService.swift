//
//  CurrencyConverterService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 09/04/2021.
//

import Foundation

let FIXER_IO_ACCESS_KEY = "35a65c4c0c6a14b719046795b7a5f816"

let CURRENCY_JSON = """
    {
      "success": true,
      "timestamp": 1617943986,
      "base": "EUR",
      "date": "2021-04-09",
      "rates": {
        "USD": 1.190526,
        "AUD": 1.559713,
        "CAD": 1.496622,
        "PLN": 4.545487,
        "MXN": 23.971427
      }
    }
    """

class CurrencyConverterService {
    static var shared = CurrencyConverterService()
    private init() {}
    
    private let baseURL = "http://data.fixer.io/api/latest?access_key="
    
    func getRate(from base: CurrencyType, to rate: CurrencyType, completionHandler: @escaping ((Double) -> Void)) {
        let completeEndPoint = "\(baseURL)\(FIXER_IO_ACCESS_KEY)&base=\(base.rawValue)&symbols=\(rate.rawValue)"
        let completeURL = URL(string: completeEndPoint)!
        let request = URLRequest(url: completeURL)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { _data, _response, _error in
            guard _error == nil else { return }
            guard let data = _data else { return }
            guard let response = _response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                print("err")
                return
            }
            print(responseJSON)
            let USDRate = responseJSON.rates.USD
            DispatchQueue.main.async {
                completionHandler(USDRate)
            }
            // TODO: Remove the following code -> Used for testing purposes
//            let jsonData = CURRENCY_JSON.data(using: .utf8)!
//            guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: jsonData) else {
//                print("not correct")
//                return
//            }
//            print(responseJSON)
//            print(responseJSON.rates)
        }
        task.resume()
    }
}
