//
//  Translation.swift
//  TravelApp
//
//  Created by Raphaël Payet on 30/04/2021.
//

import Foundation

struct Translation: Decodable {
    let data: TranslationData
}

struct TranslationData: Decodable {
    let translations: [TranslatedText]
}

struct TranslatedText: Decodable {
    let translatedText: String
}
