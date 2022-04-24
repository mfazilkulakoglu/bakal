//
//  SignInVC.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit

class SignInVC: UIViewController {
    
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
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("New user? Create an account", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        return button
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "tezgah"))
        header.addSubview(backgroundImageView)
        return header
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.width,
                                  height: view.height/3.0)
        emailText.frame = CGRect(x: 25,
                                 y: headerView.bottom + 40,
                                 width: view.width - 50,
                                 height: 52)
        passwordText.frame = CGRect(x: 25,
                                    y: emailText.bottom + 10,
                                    width: view.width - 50,
                                    height: 52)
        signInButton.frame = CGRect(x: 25,
                                    y: passwordText.bottom + 10,
                                    width: view.width - 50,
                                    height: 52)
        signUpButton.frame = CGRect(x: 25,
                                    y: signInButton.bottom + 20,
                                    width: view.width - 50,
                                    height: 52)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        initializeHideKeyboard()
        signInButton.addTarget(self,
                               action: #selector(didTapSignInButton),
                               for: .touchUpInside)
        signUpButton.addTarget(self,
                               action: #selector(didTapSignUpButton),
                               for: .touchUpInside)
        emailText.delegate = self
        passwordText.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(emailText)
        view.addSubview(passwordText)
        view.addSubview(headerView)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    
    @objc func didTapSignInButton() {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        
        AuthManager.shared.signInUser(email: emailText.text!, password: passwordText.text!) { success in
            if success == "Customer" {
                self.performSegue(withIdentifier: "signInToCustomer", sender: nil)
                self.emailText.text = ""
                self.passwordText.text = ""
            } else if success == "Dealer" {
                self.performSegue(withIdentifier: "signInToDealer", sender: nil)
                self.emailText.text = ""
                self.passwordText.text = ""
            } else {
                self.makeAlert(title: "Error", message: success)
            }
        }
        
        
    }
    
    @IBAction func unwindToSignInFromCustomer(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func unwindToSignInFromDealer(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    @objc func didTapSignUpButton() {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    
    
}

extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailText {
            passwordText.becomeFirstResponder()
        } else if textField == passwordText {
            didTapSignUpButton()
        }
        return true
    }
}
