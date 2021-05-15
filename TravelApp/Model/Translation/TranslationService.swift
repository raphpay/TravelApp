//
//  TranslationService.swift
//  TravelApp
//
//  Created by Raphaël Payet on 30/04/2021.
//

import Foundation

class TranslationService {
    
    // MARK: - Properties
    static var shared = TranslationService()
    private init() {}
    private let API_KEY = "AIzaSyByo6EBAUVDAqNVhR903gxLbirypEQW22s"
    
    private let baseStringURL = "https://translation.googleapis.com/language/translate/v2?"
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }

    
    // MARK: - Public functions
    func getTranslation(baseText: String, targetLanguage: Language, completion: @escaping ((_ success: Bool, _ translatedText: String?) -> Void)) {
        let completeStringURL = "https://translation.googleapis.com/language/translate/v2?key=\(API_KEY)&q=\(baseText)&target=\(targetLanguage.info.code)&format=text"
        let urlString = completeStringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlString!) else {
            completion(false, nil)
            return
        }
        let request = URLRequest(url: url)
        task?.cancel()
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
            }
        })
        task?.resume()
    }
}
