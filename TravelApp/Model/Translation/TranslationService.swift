//
//  TranslationService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 30/04/2021.
//

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
    
    var flag: UIImage {
        switch self {
        case .english:
            return UIImage(named: "usa_flag")!
        case .french:
            return UIImage(named: "fr_flag")!
        }
    }
    
    var displayText: String {
        switch self {
        case .english:
            return "English"
        case .french:
            return "Français"
        }
    }
    
    var textViewPlaceholder: String {
        switch self {
        case .english:
            return "Hello ! Enter the text to translate here!"
        case .french:
            return "Bonjour ! Entrez le texte à traduire ici !"
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
    func getTranslation(baseText: String, targetLanguage: Language, completion: @escaping ((_ success: Bool, _ translatedText: String?) -> Void)) {
//        let completeStringURL = baseStringURL + "key=" + API_KEY + "&q=\(baseText)" + "&source=\(Language.english.code)" + "&target=\(targetLanguage)"
        let completeStringURL = "https://translation.googleapis.com/language/translate/v2?key=\(API_KEY)&q=\(baseText)&target=\(targetLanguage.code)"
        var urlString = completeStringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlString!) else {
            completion(false, nil)
            return
        }
        print(baseText)
        let request = URLRequest(url: url)
        task = session.dataTask(with: request, completionHandler: { (_data, _response, _error) in
            DispatchQueue.main.async {
                guard _error == nil else {
                    completion(false, nil)
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
                print(translatedText)
                let utf8Data = Data(translatedText.utf8)
                print(utf8Data)
                let string = String(describing: translatedText.cString(using: String.Encoding.utf8))
                print(string)
                completion(true, translatedText)
            }
        })
        task?.resume()
    }
}
