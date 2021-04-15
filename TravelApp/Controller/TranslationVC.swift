//
//  TranslationVC.swift
//  TravelApp
//
//  Created by Raphaël Payet on 05/04/2021.
//

import UIKit

class TranslationVC : UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var firstBackgroundView: UIView!
    @IBOutlet weak var secondBackgroundView: UIView!
    @IBOutlet weak var leftFlag: UIImageView!
    @IBOutlet weak var leftLanguageLabel: UILabel!
    @IBOutlet weak var rightFlag: UIImageView!
    @IBOutlet weak var rightLanguageLabel: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var translateLabel: UILabel!
    
    
    // MARK: - Actions
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        print("translateButtonTapped")
    }
    @IBAction func entryCopyButtonTapped(_ sender: UIButton) {
        print("entryCopyButton")
    }
    @IBAction func translatedTextCopyButtonTapped(_ sender: Any) {
        print("translatedTextCopyButton")
    }
    
    
    // MARK: - Override methods
    override func viewDidLoad() {
        styleView()
        title = "Translate"
    }
    
    
    // MARK: - Private methods
    private func styleView() {
        firstBackgroundView.layer.cornerRadius = 10
        secondBackgroundView.layer.cornerRadius = 10
    }
}
