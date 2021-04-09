//
//  TranslationVC.swift
//  TravelApp
//
//  Created by Raphaël Payet on 05/04/2021.
//

import UIKit

class TranslationVC : UIViewController {
    
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var leftFlag: UIImageView!
    @IBOutlet weak var leftCountryLabel: UILabel!
    @IBOutlet weak var rightFlag: UIImageView!
    @IBOutlet weak var rightCountryLabel: UILabel!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var bottomTextView: UITextView!
    
    @IBAction func exchangeButtonTapped(_ sender: UIButton) {
    }
    @IBAction func topCopyButtonTapped(_ sender: UIButton) {
    }
    @IBAction func bottomCopyButtonTapped(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        styleView()
    }
    
    func styleView() {
        topBackgroundView.layer.cornerRadius = 10
        bottomBackgroundView.layer.cornerRadius = 10
    }
}
