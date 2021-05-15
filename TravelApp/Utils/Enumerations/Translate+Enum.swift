//
//  Translate+Enum.swift
//  TravelApp
//
//  Created by Raphaël Payet on 15/05/2021.
//

import Foundation

enum Language {
    case english, french
    
    var info: (code: String, text: String, placeholder: String) {
        switch self {
        case .english:
            return ("en", "English", "Hello ! Enter the text to translate here!")
        case .french:
            return ("fr", "Français", "Bonjour ! Entrez le texte à traduire ici !")
        }
    }
    
    var flag: String {
        switch self {
        case .english:
            return "usa_flag"
        case .french:
            return "fr_flag"
        }
    }
}
