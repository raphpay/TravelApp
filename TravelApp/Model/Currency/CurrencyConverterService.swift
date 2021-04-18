//
//  CurrencyConverterService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 09/04/2021.
//

import Foundation

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
    private let ACCESS_KEY = "35a65c4c0c6a14b719046795b7a5f816"
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }
    
    func getRate(from base: CurrencyType, to rate: CurrencyType, completionHandler: @escaping ((_ rate: Double?, _ success: Bool) -> Void)) {
        // The reason of the failed tests ?
        guard let request = createRequest() else {
            completionHandler(nil, false)
            return
        }
        task?.cancel()
        task = session.dataTask(with: request) { _data, _response, _error in
            DispatchQueue.main.async {
                guard _error == nil else { return }
                guard let data = _data else { return }
                guard let response = _response as? HTTPURLResponse,
                      response.statusCode == 200 else { return }
                guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                    completionHandler(nil, false)
                    return
                }
                let USDRate = responseJSON.rates.USD
                if base == .euro {
                    completionHandler(USDRate, true)
                } else {
                    let EURRate = 1 / USDRate
                    completionHandler(EURRate, true)
                }
            }
        }
        task?.resume()
    }
    
    private func createRequest() -> URLRequest? {
        let completeEndPoint = "\(baseURL)\(ACCESS_KEY)&base=\(CurrencyType.euro.info.code)&symbols=\(CurrencyType.usDollar.info.code)"
        let url = URL(string: completeEndPoint)!
        let request = URLRequest(url: url)
        return request
    }
    
    
    
}
