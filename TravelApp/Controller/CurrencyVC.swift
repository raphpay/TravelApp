//
//  CurrencyVC.swift
//  TravelApp
//
//  Created by Raphaël Payet on 05/04/2021.
//

import UIKit

class CurrencyVC : UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var marketOrderLabel: UILabel!
    @IBOutlet weak var firstContainerView: UIView!
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var convertButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var invertButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func invertButtonTapped(_ sender: UIButton) {
        if baseCurrency == .euro {
            convertUITo(.usDollar, from: .euro)
            
            service.getRate(from: .usDollar, to: .euro) { (_value, success) in
                guard let value = _value else {
                    self.presentAlert(message: Alert.currency.message)
                    return
                }
                let roundedValue = value.round(to: 3)
                self.marketOrderLabel.text = "Market order : 1\(CurrencyType.usDollar.info.symbol) = \(roundedValue)\(CurrencyType.euro.info.symbol)"
                if let firstText = self.firstTextField.text,
                   !firstText.isEmpty,
                   let textValue = Double(firstText) {
                    let calculatedValue = roundedValue * textValue // Cross product
                    let calculatedRoundValue = calculatedValue.round(to: 3)
                    self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.usDollar.info.symbol)"
                }
            }
            
            baseCurrency = .usDollar
            animateViews(rotationAngle: .pi)
        } else {
            convertUITo(.euro, from: .usDollar)
            baseCurrency = .euro
            service.getRate(from: .euro, to: .usDollar) { (_value, success) in
                guard let value = _value else {
                    self.presentAlert(message: Alert.currency.message)
                    return
                }
                let roundedValue = value.round(to: 3)
                self.marketOrderLabel.text = "Market order : 1\(CurrencyType.euro.info.symbol) = \(roundedValue)\(CurrencyType.usDollar.info.symbol)"
                if let firstText = self.firstTextField.text,
                   !firstText.isEmpty,
                   let textValue = Double(firstText) {
                    let calculatedValue = roundedValue * textValue // Cross product
                    let calculatedRoundValue = calculatedValue.round(to: 3)
                    self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.euro.info.symbol)"
                }
            }
            animateViews(rotationAngle: 0)
        }
    }
    @IBAction func firstTextFieldDidBegin(_ sender: Any) {
        firstTextFieldIsOpen = true
        secondTextFieldIsOpen = false
    }
    @IBAction func secondTextFieldDidBegin(_ sender: Any) {
        firstTextFieldIsOpen = false
        secondTextFieldIsOpen = true
    }
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        if baseCurrency == .euro {
            service.getRate(from: .euro, to: .usDollar) { (_value, success) in
                guard let value = _value,
                        let baseValue = self.getValue(from: self.firstTextField) else {
                    self.presentAlert(message: Alert.currencyWrongEntry.message)
                    return
                }
                
                guard success else {
                    self.presentAlert(message: Alert.currency.message)
                    return
                }
                let calculatedValue = baseValue * value
                let calculatedRoundValue = calculatedValue.round(to: 3)
                self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.usDollar.info.symbol)"
            }
        } else {
            service.getRate(from: .usDollar, to: .euro) { (_value, success) in
                guard let value = _value,
                        let baseValue = self.getValue(from: self.firstTextField) else {
                    self.presentAlert(message: Alert.currencyWrongEntry.message)
                    return
                }
                guard success else {
                    self.presentAlert(message: Alert.currency.message)
                    return
                }
                

                let calculatedValue = baseValue * value
                let calculatedRoundValue = calculatedValue.round(to: 3)
                self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.euro.info.symbol)"
            }
        }
    }
    
    // MARK: - Properties
    lazy private var textFields : [UITextField] = [firstTextField, secondTextField]
    var firstTextFieldIsOpen = false
    var secondTextFieldIsOpen = false
    var baseCurrency: CurrencyType = .euro
    var firstValue: Double = 0
    var secondValue: Double = 0
    var euroValue: Double = 1
    var usDollarValue: Double = 1
    private let service = CurrencyConverterService.shared
    
    @objc func tapDone() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.convertButtonBottomConstraint.constant = keyboardSize.height - 60
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.convertButtonBottomConstraint.constant = 16
    }
    // MARK: - Override Methods
    override func viewDidLoad() {
        title = "Currency"
        setupUI()
        setupTextFields()
        service.getRate(from: .euro, to: .usDollar) { (_value, success) in
            guard let value = _value else {
                self.presentAlert(message: Alert.currency.message)
                return
            }
            let roundedValue = value.round(to: 3)
            self.marketOrderLabel.text = "Market Order: \(self.euroValue)\(CurrencyType.euro.info.symbol) = \(roundedValue)\(CurrencyType.usDollar.info.symbol)"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Private Methods
    private func setupUI() {
        firstContainerView.layer.cornerRadius = 10
        secondContainerView.layer.cornerRadius = 10
        convertButton.layer.cornerRadius = 10
    }
    
    private func setupTextFields() {
        for textfield in textFields {
            textfield.delegate = self
            textfield.addDoneCancelToolbar(onDone: (target: self, action: #selector(tapDone)), onCancel: nil)
        }
    }
    
    private func getValue(from textField: UITextField) -> Double? {
        guard let text = textField.text,
              let value = Double(text) else { return nil }
        return value
    }
    
    private func convertUITo(_ baseCurrency: CurrencyType, from currency: CurrencyType) {
        // First part
        firstCurrencyLabel.text = baseCurrency.info.code
        firstTextField.placeholder = "1\(baseCurrency.info.symbol)"
        // Second part
        secondCurrencyLabel.text = currency.info.code
        secondTextField.placeholder = "1\(currency.info.symbol)"
        // Button
        convertButton.setTitle("Convert \(baseCurrency.info.code) to \(currency.info.code)", for: .normal)
    }
    
    private func animateViews(rotationAngle: CGFloat) {
        marketOrderLabel.alpha = 0
        firstCurrencyLabel.alpha = 0
        secondCurrencyLabel.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.marketOrderLabel.alpha = 1
            self.firstCurrencyLabel.alpha = 1
            self.secondCurrencyLabel.alpha = 1
        }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            self.invertButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
}


// MARK: - Extensions
extension CurrencyVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let baseText = textField.text,
             let baseValue = Double(baseText) else { return false }
        let roundedBaseValue = baseValue.round(to: 3)
        if baseCurrency == .euro {
            service.getRate(from: .euro, to: .usDollar) { (_value, success) in
                guard let value = _value else {
                    self.presentAlert(message: Alert.currency.message)
                    return
                }
                let calculatedValue = roundedBaseValue * value // Cross product
                let calculatedRoundValue = calculatedValue.round(to: 3)
                self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.usDollar.info.symbol)"
            }
        } else {
            service.getRate(from: .usDollar, to: .euro) { (_value, success) in
                guard let value = _value else {
                    self.presentAlert(message: Alert.currency.message)
                    return
                }
                let calculatedValue = roundedBaseValue * value
                let calculatedRoundValue = calculatedValue.round(to: 3)
                self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.euro.info.symbol)"
            }
        }
        tapDone()
        return true
    }
}
