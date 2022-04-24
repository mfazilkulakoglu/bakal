//
//  AuthManager.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import FirebaseAuth
import Darwin

public class AuthManager {
    static let shared = AuthManager()
    
    public func registerNewUser(email: String, password: String, accType: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil, authResult != nil else {
                completion(false)
                return
            }
            DatabaseManager.shared.insertNewUser(with: email, accType: accType) { inserted in
                if inserted {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
            }
        }
    }
    
    public func signInUser(email: String, password: String, completion: @escaping (String) -> Void) {
        DatabaseManager.shared.getAccountType(email: email) { success in
            if success == "Customer" || success == "Dealer" {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    guard authResult != nil, error == nil else {
                        completion(error!.localizedDescription)
                        return
                    }
                    completion(success)
                }
            } else {
                completion(success)
            }
        }
    }
    
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            completion(false)
            return
        }
    }
    
    public func curUserEmail(completion: @escaping (String) -> Void) {
        if let email = Auth.auth().currentUser?.email {
            completion(email)
        } else {
            completion("")
        }
    }
}
