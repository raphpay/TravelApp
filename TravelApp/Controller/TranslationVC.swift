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
    @IBOutlet var containerView: UIView!
    
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
    
    
    // MARK: - Properties
    
    
    // MARK: - Override methods
    override func viewDidLoad() {
        styleView()
        title = "Translate"
        entryTextView.delegate = self
        translatedTextView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        containerView.addGestureRecognizer(tap)
        
        TranslationService.shared.getTranslation(baseText: "Hello", targetLanguage: Language.french.code) { (success, _translatedText) in
            guard success,
                  let translatedText = _translatedText else { return }
            print(translatedText)
        }
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Private methods
    private func styleView() {
        firstBackgroundView.layer.cornerRadius = 10
        secondBackgroundView.layer.cornerRadius = 10
    }
}

extension TranslationVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
