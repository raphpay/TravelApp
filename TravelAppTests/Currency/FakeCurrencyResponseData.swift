//
//  FakeCurrencyResponseData.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 18/04/2021.
//

import Foundation

class FakeCurrencyResponseData {
    // On met une URL au hasard, car ici on ne s'intéresse ici qu'au code HTTP, c'est la seule chose que l'on contrôle.
    static var currencyCorrectData: Data  {
        let bundle = Bundle(for: FakeCurrencyResponseData.self)
        let url = bundle.url(forResource: "Currency", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let currencyIncorrectData = "erreur".data(using: .utf8)!
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://apple.com")!,
                                            statusCode: 200,
                                            httpVersion: nil, headerFields: nil)
    
    static let responseNotOK = HTTPURLResponse(url: URL(string: "https://apple.com")!,
                                            statusCode: 500,
                                            httpVersion: nil, headerFields: nil)
    // On simule le fait qu'il y a une erreur
    class CurrencyError: Error {}
    static let error = CurrencyError()
}
