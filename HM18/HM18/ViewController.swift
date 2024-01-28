//
//  ViewController.swift
//  HM18
//
//  Created by Evgeny Sakun on 28.01.24.
//

import UIKit

class ViewController: UIViewController {

    let textField = UITextField()
    let label = UILabel()
    let button = UIButton()
    
    var centerYTextFieldConstraint = NSLayoutConstraint()
    let tapViewGesture = UITapGestureRecognizer()
    let characterLimit = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        setupKeyboardHiding()
        setupTextField()
        setupButton()
        setupLabel()
    }
    
    func setupKeyboardHiding() {
        tapViewGesture.addTarget(self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapViewGesture)
    }
    
    func setupTextField() {
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.placeholder = "enter text  . . ."
        textField.keyboardType = .default
        textField.textAlignment = .left
        
        
        view.addSubview(textField)
        setupTextFieldConstraints()
    }
    
    func setupButton() {
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.setTitle("SEND", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        view.addSubview(button)
        setupButtonConstraints()
        
        button.addTarget(self, action: #selector(sendTextToLabel), for: .touchUpInside)
    }
    
    func setupLabel() {
        
        view.addSubview(label)
        setupLabelConstraints()
    }
    
    func setupTextFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        centerYTextFieldConstraint = textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYTextFieldConstraint,
            textField.widthAnchor.constraint(equalToConstant: 200),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupButtonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func keyboardAppeared(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            centerYTextFieldConstraint.isActive = false
            centerYTextFieldConstraint = textField.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-textField.frame.height/2-20-button.frame.height-20)
            centerYTextFieldConstraint.isActive = true
        }
    }
    
    @objc func keyboardDisappeared() {
        centerYTextFieldConstraint.isActive = false
        centerYTextFieldConstraint = textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        centerYTextFieldConstraint.isActive = true
    }
    
    @objc func sendTextToLabel() {
        label.text = textField.text
        textField.text = nil
    }


}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        return newLength <= characterLimit
    }
}
