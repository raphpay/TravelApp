//
//  Double+Ext.swift
//  TravelApp
//
//  Created by Raphaël Payet on 16/04/2021.
//

import UIKit

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func convertFromKelvinToCelsius() -> Double {
        return self - 273.15
    }
}
