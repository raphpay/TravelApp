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
    
    // MARK: - Properties
    lazy private var textFields : [UITextField] = [firstTextField, secondTextField]
    var firstTextFieldIsOpen = false
    var secondTextFieldIsOpen = false
    var baseCurrency: CurrencyType = .euro
    var firstValue: Double = 0
    var secondValue: Double = 0
    var euroValue: Double = 1
    var usDollarValue: Double = 1
    
    // MARK: - Actions
    @IBAction func invertButtonTapped(_ sender: UIButton) {
        if baseCurrency == .euro {
            convertUITo(.usDollar, from: .euro)
            CurrencyConverterService.shared.getRate(from: .usDollar, to: .euro) { (_value, success) in
                guard let value = _value else { return }
                let roundedValue = value.round(to: 3)
                self.marketOrderLabel.text = "Market order : 1\(CurrencyType.usDollar.info.symbol) = \(roundedValue)\(CurrencyType.euro.info.symbol)"
            }
            baseCurrency = .usDollar
        } else {
            convertUITo(.euro, from: .usDollar)
            baseCurrency = .euro
            CurrencyConverterService.shared.getRate(from: .euro, to: .usDollar) { (_value, success) in
                guard let value = _value else { return }
                let roundedValue = value.round(to: 3)
                self.marketOrderLabel.text = "Market order : 1\(CurrencyType.euro.info.symbol) = \(roundedValue)\(CurrencyType.usDollar.info.symbol)"
            }
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
            CurrencyConverterService.shared.getRate(from: .euro, to: .usDollar) { (_value, success) in
                guard let value = _value,
                        let baseValue = self.getValue(from: self.firstTextField) else { return }
                let calculatedValue = baseValue * value
                let calculatedRoundValue = calculatedValue.round(to: 3)
                self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.usDollar.info.symbol)"
            }
        } else {
            CurrencyConverterService.shared.getRate(from: .usDollar, to: .euro) { (_value, success) in
                guard let value = _value,
                        let baseValue = self.getValue(from: self.firstTextField) else { return }
                let calculatedValue = baseValue * value
                let calculatedRoundValue = calculatedValue.round(to: 3)
                self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.euro.info.symbol)"
            }
        }
    }
    
    @objc func tapDone() {
        self.view.endEditing(true)
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        title = "Currency"
        setupUI()
        setupTextFields()
        CurrencyConverterService.shared.getRate(from: .euro, to: .usDollar) { (_value, success) in
            guard let value = _value else { return }
            let roundedValue = value.round(to: 3)
            self.marketOrderLabel.text = "Market Order: \(self.euroValue)\(CurrencyType.euro.info.symbol) = \(roundedValue)\(CurrencyType.usDollar.info.symbol)"
        }
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
}


// MARK: - Extensions
extension CurrencyVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // TODO : Convert the value
        guard let baseText = textField.text,
             let baseValue = Double(baseText) else { return false }
        let roundedBaseValue = baseValue.round(to: 3)
        if baseCurrency == .euro {
            CurrencyConverterService.shared.getRate(from: .euro, to: .usDollar) { (_value, success) in
                guard let value = _value else { return }
                let calculatedValue = roundedBaseValue * value // Cross product
                let calculatedRoundValue = calculatedValue.round(to: 3)
                self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.usDollar.info.symbol)"
            }
        } else {
            CurrencyConverterService.shared.getRate(from: .usDollar, to: .euro) { (_value, success) in
                guard let value = _value else { return }
                let calculatedValue = roundedBaseValue * value
                let calculatedRoundValue = calculatedValue.round(to: 3)
                self.secondTextField.text = "\(calculatedRoundValue)\(CurrencyType.euro.info.symbol)"
            }
        }
        tapDone()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

    // TODO : Use this code with translate part
//    func textViewDidEndEditing(_ textView: UITextView) {
//            if noteText.text == "" {
//                noteText.textColor = greyColorPlaceholder
//                noteText.text = placeholder
//            }
//        }
}
