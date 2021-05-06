//
//  UIViewController+Ext.swift
//  TravelApp
//
//  Created by Raphaël Payet on 06/05/2021.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String? = "Oups !",
                      message: String? = "An error occured. Please try again later",
                      preferredStyle: UIAlertController.Style? = UIAlertController.Style.alert,
                      action: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        if let action = action {
            alertController.addAction(action)
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
        }
        self.present(alertController, animated: true)
    }
}
