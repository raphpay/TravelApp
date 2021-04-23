//
//  CurrencyConverterService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 09/04/2021.
//

import Foundation

// TODO : Fix button to keyboard
// TODO : Terminer switch conversion

// MARK: - Enumeration
enum CurrencyType {
    case euro
    case usDollar

    var info: (code: String, symbol: String) {
        switch self {
        case .euro:
            return ("EUR", "€")
        case .usDollar:
            return ("USD", "$")
        }
    }
}


class CurrencyConverterService {
    
    // MARK: - Properties
    static var shared = CurrencyConverterService()
    private init() {}
    
    private let baseURL = "http://data.fixer.io/api/latest?access_key="
    private let ACCESS_KEY = "35a65c4c0c6a14b719046795b7a5f816"
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }
    
    
    // MARK: - Public Methods
    func getRate(from base: CurrencyType, to rate: CurrencyType, completionHandler: @escaping ((_ rate: Double?, _ success: Bool) -> Void)) {
        guard let request = createRequest() else {
            completionHandler(nil, false)
            return
        }
        task?.cancel()
        task = session.dataTask(with: request) { _data, _response, _error in
            DispatchQueue.main.async {
                guard _error == nil else {
                    completionHandler(nil, false)
                    return
                }
                guard let data = _data else {
                    completionHandler(nil, false)
                    return
                }
                guard let response = _response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completionHandler(nil, false)
                    return
                }
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
    
    
    // MARK: - Helper Methods
    private func createRequest() -> URLRequest? {
        let completeEndPoint = "\(baseURL)\(ACCESS_KEY)&base=\(CurrencyType.euro.info.code)&symbols=\(CurrencyType.usDollar.info.code)"
        let url = URL(string: completeEndPoint)!
        let request = URLRequest(url: url)
        return request
    }
}
