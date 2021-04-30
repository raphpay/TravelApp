//
//  TranslationService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 30/04/2021.
//

import Foundation
import UIKit

enum Language {
    case english, french
    
    var code: String {
        switch self {
        case .english:
            return "en"
        case .french:
            return "fr"
        }
    }
}


class TranslationService {
    
    // MARK: - Properties
    static var shared = TranslationService()
    private init() {}
    private let API_KEY = "AIzaSyByo6EBAUVDAqNVhR903gxLbirypEQW22s"
    
    private let baseStringURL = "https://translation.googleapis.com/language/translate/v2?"
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    
    // MARK: - Public functions
    func getTranslation(baseText: String, targetLanguage: String, completion: @escaping ((_ success: Bool, _ translatedText: String?) -> Void)) {
//        let completeStringURL = baseStringURL + "key=" + API_KEY + "&q=\(baseText)" + "&source=\(Language.english.code)" + "&target=\(targetLanguage)"
        let completeStringURL = "https://translation.googleapis.com/language/translate/v2?key=\(API_KEY)&q=\(baseText)&target=\(targetLanguage)"
        guard let url = URL(string: completeStringURL) else {
            completion(false, nil)
            return
        }
        let request = URLRequest(url: url)
        task = session.dataTask(with: request, completionHandler: { (_data, _response, _error) in
            guard _error == nil else {
                completion(false, nil)
                print(_error!.localizedDescription)
                return
            }
            guard let data = _data else {
                completion(false, nil)
                return
            }
            print(data)
            guard let response = _response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(false, nil)
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(Translation.self, from: data) else {
                completion(false, nil)
                return
            }
            let translatedText = responseJSON.data.translations[0].translatedText
            completion(true, translatedText)
        })
        task?.resume()
    }
}
