//
//  ProfileViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(didTapLogOutButton))
    }
    
    
    @objc private func didTapLogOutButton() {
        AuthManager.shared.logOut { success in
            if success {
                performSegue(withIdentifier: "unwindToSignInFromCustomer", sender: self)
            } else {
                self.makeAlert(title: "Error", message: "Could not log out")
            }
        }
        
    }
    
    
}
