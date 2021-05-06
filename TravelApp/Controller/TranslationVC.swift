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
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
                self.translateButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        } else {
            leftFlag.image = Language.french.flag
            leftLanguageLabel.text = Language.french.displayText
            
            rightFlag.image = Language.english.flag
            rightLanguageLabel.text = Language.english.displayText
            
            baseLanguage = .french
            
            entryTextView.text = Language.french.textViewPlaceholder
            translatedTextView.text = Language.english.textViewPlaceholder
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
                self.translateButton.transform = .identity
            }
        }
    }
    
    @IBAction func entryCopyButtonTapped(_ sender: UIButton) {
        copyToClipboard(from: entryTextView)
    }
    @IBAction func translatedTextCopyButtonTapped(_ sender: Any) {
        copyToClipboard(from: translatedTextView)
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Properties
    var baseLanguage = Language.french
    
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
        
        TranslationService.shared.getTranslation(baseText: text, targetLanguage: targetLanguage) { (success, _translatedText) in
            guard success,
                  let translatedText = _translatedText else {
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
}

extension TranslationVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        translate(text: text)
        textView.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        resetPlaceHolders(in: textView)
        textView.resignFirstResponder()
        guard let text = textView.text else {
            return false
        }
        translate(text: text)
        return true
    }
}
