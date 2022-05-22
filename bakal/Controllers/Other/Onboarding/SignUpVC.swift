//
//  SignUpVC.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit

class SignUpVC: UIViewController {
    
    private let customerOrDealer: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Customer", "Dealer"])
        return control
    }()
    
    private let nameText: UITextField = {
        let field = UITextField()
        field.placeholder = "Name, Surname..."
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        field.returnKeyType = .continue
        return field
    }()
    
    private let emailText: UITextField = {
        let field = UITextField()
        field.placeholder = "Email..."
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        field.returnKeyType = .continue
        return field
    }()
    
    private let passwordText: UITextField = {
        let field = UITextField()
        field.placeholder = "Password..."
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        field.returnKeyType = .continue
        field.isSecureTextEntry = true
        return field
    }()
    
    private let secondPasswordText: UITextField = {
        let field = UITextField()
        field.placeholder = "Verify password..."
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        field.returnKeyType = .continue
        field.isSecureTextEntry = true
        return field
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customerOrDealer.frame = CGRect(x: 25,
                                        y: 70,
                                        width: view.width - 50,
                                        height: 33)
        nameText.frame = CGRect(x: 25,
                                y: customerOrDealer.bottom + 30,
                                width: view.width - 50,
                                height: 52)
        emailText.frame = CGRect(x: 25,
                                 y: nameText.bottom + 10,
                                 width: view.width - 50,
                                 height: 52)
        passwordText.frame = CGRect(x: 25,
                                    y: emailText.bottom + 10,
                                    width: view.width - 50,
                                    height: 52)
        secondPasswordText.frame = CGRect(x: 25,
                                          y: passwordText.bottom + 10,
                                          width: view.width - 50,
                                          height: 52)
        signUpButton.frame = CGRect(x: 25,
                                    y: secondPasswordText.bottom + 10,
                                    width: view.width - 50,
                                    height: 52)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
        initializeHideKeyboard()
        signUpButton.addTarget(self,
                               action: #selector(didTapSignUpButton),
                               for: .touchUpInside)
        
    }
    
    private func addSubviews() {
        view.addSubview(customerOrDealer)
        view.addSubview(nameText)
        view.addSubview(emailText)
        view.addSubview(passwordText)
        view.addSubview(secondPasswordText)
        view.addSubview(signUpButton)
    }
    
    @objc private func didTapSignUpButton() {
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        secondPasswordText.resignFirstResponder()
        
        if customerOrDealer.selectedSegmentIndex != -1 {
            if nameText.text != nil {
                if emailText.text != nil {
                    if passwordText.text != nil {
                        if secondPasswordText.text == passwordText.text {
                            let accTypeIndex = customerOrDealer.selectedSegmentIndex
                            let accType = customerOrDealer.titleForSegment(at: accTypeIndex)
                            AuthManager.shared.registerNewUser(email: emailText.text!, password: passwordText.text!, accType: accType!, nameSurname: nameText.text!) { registered in
                                DispatchQueue.main.async {
                                    if registered {
                                        if self.customerOrDealer.selectedSegmentIndex == 0 {
                                            self.performSegue(withIdentifier: "signUpToCustomer", sender: nil)
                                            
                                        } else {
                                            self.performSegue(withIdentifier: "signUpToDealer", sender: nil)
                                            
                                        }
                                    }
                                }
                            }
                            
                        } else {
                            self.makeAlert(title: "Error", message: "Passwords are not the same!")
                        }
                    }
                }
            } else {
                self.makeAlert(title: "Error", message: "Please write your name")
            }
        } else {
            self.makeAlert(title: "Error", message: "Please choose your account type")
        }
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameText {
            emailText.becomeFirstResponder()
        }
        else if textField == emailText {
            passwordText.becomeFirstResponder()
        }
        else if textField == passwordText {
            secondPasswordText.becomeFirstResponder()
        }
        else if textField == secondPasswordText {
            becomeFirstResponder()
        }
        return true
    }
}
