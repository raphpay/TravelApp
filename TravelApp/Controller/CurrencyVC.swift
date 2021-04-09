//
//  CurrencyVC.swift
//  TravelApp
//
//  Created by Raphaël Payet on 05/04/2021.
//

import UIKit

enum CurrencyType: String {
    case euro = "EUR"
    case usDollar = "USD"
}

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
    var firstValue: Double = 0
    var secondValue: Double = 0
    
    // MARK: - Actions
    @IBAction func invertButtonTapped(_ sender: UIButton) {
        // TODO : Convert 1€ to 1$ or vice-versa
        if firstCurrencyLabel.text == CurrencyType.euro.rawValue {
            firstCurrencyLabel.text = CurrencyType.usDollar.rawValue
            firstTextField.placeholder = "0$"
            secondCurrencyLabel.text = CurrencyType.euro.rawValue
            secondTextField.placeholder = "0€"
            convertButton.setTitle("Convert \(CurrencyType.usDollar.rawValue) to \(CurrencyType.euro.rawValue)", for: .normal)
        } else {
            firstCurrencyLabel.text = CurrencyType.euro.rawValue
            firstTextField.placeholder = "0€"
            secondCurrencyLabel.text = CurrencyType.usDollar.rawValue
            secondTextField.placeholder = "0$"
            convertButton.setTitle("Convert \(CurrencyType.euro.rawValue) to \(CurrencyType.usDollar.rawValue)", for: .normal)
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
        CurrencyConverterService.shared.getRate(from: .euro, to: .usDollar)
    }
    
    @objc func tapDone() {
        self.view.endEditing(true)
        if firstTextFieldIsOpen {
            getValue(from: firstTextField)
        } else if secondTextFieldIsOpen {
            getValue(from: secondTextField)
        }
    }
    
    private func getValue(from textField: UITextField) -> Double? {
        guard let text = textField.text,
              let value = Double(text) else { return nil }
        print(value)
        return value
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        setupUI()
        setupTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Configuration Methods
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
}


// MARK: - Extensions
extension CurrencyVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tapDone()
        return true
    }
}
