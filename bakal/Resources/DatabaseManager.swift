//
//  DatabaseManager.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//


import Foundation
import FirebaseFirestore


public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    private var reference: DocumentReference!
    
    public func insertNewUser(with email: String, accType: String, completion: @escaping (Bool) -> Void) {
        let key = email.safeDatabaseKey()
        let id = UUID().uuidString
        let firestorePost = ["Email": "\(email)", "Account Type": accType, "Date": FieldValue.serverTimestamp(), "ID" : id] as [String : Any]
        
        reference = database.document("Users/\(key)")
        reference.setData(firestorePost) { error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    public func getAccountType(email: String, completion: @escaping (String) -> Void) {
        let key = email.safeDatabaseKey()
        reference = database.document("Users/\(key)")
        reference.getDocument { snapshot, error in
            if error == nil && snapshot != nil {
                let result = snapshot!["Account Type"] as! String
                completion(result)
            } else {
                completion(error!.localizedDescription)
            }
        }
    }
    
    public func saveStorySettings(storePost: StoreModel, completion: @escaping (Bool) -> Void) {
        
        let firestoreStorePost: [String : Any] = [
            "ID": storePost.id,
            "Email": storePost.email,
            "Store Type": storePost.storeType,
            "Store Name": storePost.storeName,
            "Address": storePost.adress,
            "Phone": storePost.phone,
            "Minimum Price": storePost.minPrice,
            "Maximum Distance": storePost.maxDistance,
            "Opening Time": storePost.openingTime,
            "Closing Time": storePost.closingTime,
            "Latitude": storePost.storeLatitude,
            "Longitude": storePost.storeLongitude
        ]
        let key = storePost.email.safeDatabaseKey()
        reference = database.document("Stores/\(key)/\(storePost.id)/Settings")
        reference.setData(firestoreStorePost) { error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    public func getAccountID(completion: @escaping (String, String) -> Void) {
        AuthManager.shared.curUserEmail { email in
            if email != "" {
                let key = email.safeDatabaseKey()
                self.reference = self.database.document("Users/\(key)")
                self.reference.getDocument { snapshot, error in
                    if error == nil && snapshot != nil {
                        let result = snapshot!["ID"] as! String
                        completion(email, result)
                    } else {
                        completion(email, "")
                    }
                }
            } else {
                completion("", "")
            }
        }
    }
    
    public func getCategories(completion: @escaping ([String], String, String) -> Void) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion([""], "", "")
                return
            }
            let keyEmail = email.safeDatabaseKey()
            let id = id
            self.reference = self.database.document("Stores/\(keyEmail)/\(id)/Categories")
            self.reference.getDocument { snapshot, error in
                if snapshot == nil {
                    completion([""], keyEmail, id)
                } else {
                    let result = snapshot?["Categories"] as? [String]
                    completion(result ?? [""], keyEmail, id)
                }
            }
        }
    }
    
    public func saveCategory(categoryName: String, completion: @escaping (Bool) -> Void) {
        getCategories { categories, email, id in
            if email == "" || id == "" {
                completion(false)
            } else if categories == [""] {
                let data: [String : Any] = ["Categories" : [categoryName]]
                self.reference = self.database.document("Stores/\(email)/\(id)/Categories")
                self.reference.setData(data, merge: true) { error in
                    if error != nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                var newCategories = categories
                newCategories.append(categoryName)
                let data: [String : Any] = ["Categories" : newCategories]
                self.reference = self.database.document("Stores/\(email)/\(id)/Categories")
                self.reference.setData(data, merge: true) { error in
                    if error != nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
    public func deleteCategory(selectedRow: Int, completion: @escaping (Bool) -> Void) {
        getCategories { categories, email, id in
            if email == "" || id == "" || categories == [""] {
                completion(false)
            } else {
                var newCategories = categories
                newCategories.remove(at: selectedRow)
                let data: [String :Any] = ["Categories" : newCategories]
                self.reference = self.database.document("Stores/\(email)/\(id)/Categories")
                self.reference.setData(data, merge: true) { error in
                    if error != nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
    public func getProducts(completion: ((([ProductMap])?) -> Void)? = nil) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion!(nil)
                return
            }
            let keyEmail = email.safeDatabaseKey()
            let id = id
            let ref = self.database.collection("Stores/\(keyEmail)/\(id)/Products")
            ref.addSnapshotListener { querrySnapshot, error in
                guard let documents = querrySnapshot?.documents else {
                    print("No documents")
                    completion!(nil)
                    return
                }
                if error != nil {
                    completion!(nil)
                } else {
                    var products = [ProductMap]()
                    products = documents.compactMap({ (queryDocumentSnapshot) -> ProductMap? in
                        return try? queryDocumentSnapshot.data(as: ProductMap.self)
//                        do {
//                            return try queryDocumentSnapshot.data(as: ProductMap.self)
//                        } catch {
//                            completion!(nil)
//                        }
//                        let data = queryDocumentSnapshot.data()
//                        let category = data["Product Category Name"] as? String ?? ""
//                        let name = data["Product Name"] as? String ?? ""
//                        let model = data["Product Map"]
//
//                        return ProductMap(proCategory: category, proName: name, model: model as! ProductModel)
                    })
                }
            }
        }
    }
    
    public func saveProducts(categoryName: String, modelName: String, model: ProductModel, completion: @escaping (Bool) -> Void) {
        getProducts { products in
    
        }
    }
    
 
}
