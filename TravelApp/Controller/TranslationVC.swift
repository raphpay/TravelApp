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
    @IBOutlet weak var translateButton: UIButton!
    
    // MARK: - Actions
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        
        if baseLanguage == .french {
            leftFlag.image = Language.english.flag
            leftLanguageLabel.text = Language.english.displayText
            
            rightFlag.image = Language.french.flag
            rightLanguageLabel.text = Language.french.displayText
            
            baseLanguage = .english
            
            entryTextView.text = Language.english.textViewPlaceholder
            translatedTextView.text = Language.french.textViewPlaceholder
            animateViews(rotationAngle: .pi)
        } else {
            leftFlag.image = Language.french.flag
            leftLanguageLabel.text = Language.french.displayText
            
            rightFlag.image = Language.english.flag
            rightLanguageLabel.text = Language.english.displayText
            
            baseLanguage = .french
            
            entryTextView.text = Language.french.textViewPlaceholder
            translatedTextView.text = Language.english.textViewPlaceholder
            
            animateViews(rotationAngle: 0)
        }
    }
    
    @IBAction func entryCopyButtonTapped(_ sender: UIButton) {
        copyToClipboard(from: entryTextView)
        presentAlert(title: "Message copied", message: "Text successfully copy to clipboard", preferredStyle: .alert)
    }
    @IBAction func translatedTextCopyButtonTapped(_ sender: Any) {
        copyToClipboard(from: translatedTextView)
        presentAlert(title: "Message copied", message: "Text successfully copy to clipboard", preferredStyle: .alert)
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Properties
    var baseLanguage = Language.french
    private let service = TranslationService.shared
    
    // MARK: - Override methods
    override func viewDidLoad() {
        styleView()
        title = "Translate"
        entryTextView.delegate = self
        entryTextView.textColor = UIColor(named: "placeholder")
        translatedTextView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        containerView.addGestureRecognizer(tap)
    }
    
    // MARK: - Private methods
    private func styleView() {
        firstBackgroundView.layer.cornerRadius = 10
        secondBackgroundView.layer.cornerRadius = 10
    }
    
    private func resetPlaceHolders(in textView : UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor(named: "placeholder")
            if baseLanguage == .french {
                textView.text = Language.french.textViewPlaceholder
            } else {
                textView.text = Language.english.textViewPlaceholder
            }
        }
    }
    
    private func translate(text: String) {
        var targetLanguage = Language.english
        if baseLanguage == .english {
            targetLanguage = .french
        } else {
            targetLanguage = .english
        }
        
        service.getTranslation(baseText: text, targetLanguage: targetLanguage) { (success, _translatedText) in
            guard success,
                  let translatedText = _translatedText else {
                self.presentAlert(message: Alert.translate.rawValue)
                return
            }
            self.translatedTextView.text = translatedText
        }
    }
    
    private func copyToClipboard(from textView: UITextView) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = ""
        guard let textToCopy = textView.text else { return }
        pasteboard.string = textToCopy
    }
    
    private func animateViews(rotationAngle: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            self.translateButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
        
        leftFlag.alpha = 0
        leftLanguageLabel.alpha = 0
        rightFlag.alpha = 0
        rightLanguageLabel.alpha = 0
        entryTextView.alpha = 0
        translatedTextView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.leftFlag.alpha = 1
            self.leftLanguageLabel.alpha = 1
            self.rightFlag.alpha = 1
            self.rightLanguageLabel.alpha = 1
            self.entryTextView.alpha = 1
            self.translatedTextView.alpha = 1
        }
    }
}

// MARK: Extensions
extension TranslationVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text,
              Int(text) == nil else {
            self.presentAlert(message: Alert.translateWrongEntry.message)
            return
        }
        translate(text: text)
        textView.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        resetPlaceHolders(in: textView)
        textView.resignFirstResponder()
        return true
    }
}
