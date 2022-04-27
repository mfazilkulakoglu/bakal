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
    private var colReference: CollectionReference!
    
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
        reference.setData(firestoreStorePost, merge: true) { error in
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
    
    //    public func getCategories(completion: @escaping ([String], String, String) -> Void) {
    //        getAccountID { email, id in
    //            guard email != "" && id != "" else {
    //                completion([""], "", "")
    //                return
    //            }
    //            let keyEmail = email.safeDatabaseKey()
    //            let id = id
    //            self.reference = self.database.document("Stores/\(keyEmail)/\(id)")
    //            self.reference.getDocument { snapshot, error in
    //                if snapshot == nil {
    //                    completion([""], keyEmail, id)
    //                } else {
    //                    let result = snapshot?["Categories"] as? [String]
    //                    completion(result ?? [""], keyEmail, id)
    //                }
    //            }
    //        }
    //    }
    //
    //    public func saveCategory(categoryName: String, completion: @escaping (Bool) -> Void) {
    //        getCategories { categories, email, id in
    //            if email == "" || id == "" {
    //                completion(false)
    //            } else if categories == [""] {
    //                self.reference = self.database.document("Stores/\(email)/\(id)/\(categoryName)")
    //                let data = ["Category Name" : categoryName]
    //                self.reference.setData(data, merge: true) { error in
    //                    if error != nil {
    //                        completion(false)
    //                    } else {
    //                        completion(true)
    //                    }
    //                }
    //            } else {
    //                var newCategories = categories
    //                newCategories.append(categoryName)
    //                let data: [String : Any] = ["Categories" : newCategories]
    //                self.reference = self.database.document("Stores/\(email)/\(id)/Categories")
    //                self.reference.setData(data, merge: true) { error in
    //                    if error != nil {
    //                        completion(false)
    //                    } else {
    //                        completion(true)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    //    public func deleteCategory(selectedRow: Int, completion: @escaping (Bool) -> Void) {
    //        getCategories { categories, email, id in
    //            if email == "" || id == "" || categories == [""] {
    //                completion(false)
    //            } else {
    //                var newCategories = categories
    //                newCategories.remove(at: selectedRow)
    //                let data: [String :Any] = ["Categories" : newCategories]
    //                self.reference = self.database.document("Stores/\(email)/\(id)/Categories")
    //                self.reference.setData(data, merge: true) { error in
    //                    if error != nil {
    //                        completion(false)
    //                    } else {
    //                        completion(true)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    public func getProducts(completion: @escaping (Result<[String : [ProductModel]]?, FetchProductError>) -> Void) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(.failure(.accountInfo))
                return
            }
            self.colReference = self.database.collection("Stores/\(id)/Products")
            self.colReference.getDocuments { querrySnapshot, error in
                guard error == nil else {
                    completion(.failure(.badUrl))
                    return
                }
                guard let data = querrySnapshot?.documents else {
                    completion(.failure(.noData))
                    return
                }
                var result = [String : [ProductModel]]()
                for document in data {
                    let product = document.data()
                    
                    let proModel = ProductModel(product["ID"]! as! String, product["Category"]! as! String, product["Name"]! as! String, product["Comment"]! as! String, product["Unit"]! as! String, product["Unit Type"]! as! String, product["Image Url"]! as! String, product["Price"]! as! String, product["Statu"]! as! String)
                    if result[proModel.productCategory] != nil {
                        result[proModel.productCategory]?.append(proModel)
                    } else {
                        result[proModel.productCategory] = [proModel]
                    }
                }
                completion(.success(result))
            }
        }
    }
    
    public func saveProducts(categoryName: String, product: ProductModel, completion: @escaping (Bool) -> Void) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(false)
                return
            }
            self.reference = self.database.document("Stores/\(id)/Products/\(product.id)")
            let data = ["Category" : product.productCategory,
                        "Name" : product.productName,
                        "Comment" : product.productComment,
                        "Unit" : product.productUnit,
                        "Unit Type" : product.productUnitType,
                        "Price" : product.productPrice,
                        "Image Url" : product.productPhoto,
                        "Statu" : product.productStatu,
                        "ID" : product.id]
            self.reference.setData(data)
            completion(true)
        
        }
    }
}

public enum FetchProductError : Error {
    case accountInfo
    case badUrl
    case noData
    case dataParseError
}
