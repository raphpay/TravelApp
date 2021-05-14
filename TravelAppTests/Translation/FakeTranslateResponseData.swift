//
//  FakeTranslateResponseData.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 04/05/2021.
//

import Foundation

class FakeTranslationResponseData {
    static var translateCorrectData: Data  {
        let bundle = Bundle(for: FakeTranslationResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let translateIncorrectData = "erreur".data(using: .utf8)!

    static let baseText = "Hello"
    static let frenchBaseText = "Salut"
    static let translatedText = "Bonjour"
    
    // We put a random URL because we only need the HTTP status code
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
