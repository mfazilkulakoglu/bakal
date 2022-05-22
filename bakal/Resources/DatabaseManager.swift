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
    private var secondReference: DocumentReference!
    private var colReference: CollectionReference!
    
    public func insertNewUser(with email: String, accType: String, nameSurname: String, completion: @escaping (Bool) -> Void) {
        let key = email.safeDatabaseKey()
        let id = UUID().uuidString
        let firestorePost = ["Email": "\(email)", "Account Type": accType, "Date": FieldValue.serverTimestamp(), "ID" : id, "Name, Surname" : nameSurname] as [String : Any]
        
        reference = database.document("Users/\(key)")
        reference.setData(firestorePost) { error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    public func getAccountType(email: String, completion: @escaping (Result<String, FetchTypeError>) -> Void) {
        let key = email.safeDatabaseKey()
        reference = database.document("Users/\(key)")
        reference.getDocument { snapshot, error in
            if error == nil || snapshot != nil {
                if let data = snapshot!.data() {
                    if let result = data["Account Type"] as? String {
                        completion(.success(result))
                    } else {
                        completion(.failure(.noAccountType))
                    }
                }
                
            } else {
                completion(.failure(.noAccountType))
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
    
    public func saveStorySettings(storePost: StoreModel) async throws -> Bool {
        
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
            "Store Image URL": storePost.storeImageUrl,
            "Latitude": storePost.storeLatitude,
            "Longitude": storePost.storeLongitude
        ]
        let key = storePost.email.safeDatabaseKey()
        reference = database.document("Dealers/\(storePost.id)/\(key)/Settings")
        try await reference.setData(firestoreStorePost, merge: true)
                secondReference = self.database.document("Stores/\(storePost.id)")
                try await secondReference.setData(firestoreStorePost, merge: true)
        return true
    }
    
    public func getSettings(completion: @escaping (Result<StoreModel, FetchProductError>) -> Void) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(.failure(.accountInfo))
                return
            }
            let key = email.safeDatabaseKey()
            self.reference = self.database.document("Dealers/\(id)/\(key)/Settings")
            self.reference.getDocument { snapshot, error in
                guard snapshot != nil && error == nil else {
                    completion(.failure(.noData))
                    return
                }
                let data = snapshot!.data()
                if data != nil {
                    let storeModel = StoreModel(email: data!["Email"] as! String, id: data!["ID"] as! String, storeType: data!["Store Type"] as! String, storeName: data!["Store Name"] as! String, adress: data!["Address"] as! String, phone: data!["Phone"] as! String, minPrice: data!["Minimum Price"] as! String, maxDistance: data!["Maximum Distance"] as! String, openingTime: data!["Opening Time"] as! String, closingTime: data!["Closing Time"] as! String, storeImageUrl: data!["Store Image URL"] as! String, storeLatitude: data!["Latitude"] as! Double, storeLongitude: data!["Longitude"] as! Double)
                    completion(.success(storeModel))
                } else {
                    completion(.failure(.badUrl))
                }
            }
        }
    }
    
    public func getProducts(completion: @escaping (Result<[String : [ProductModel]]?, FetchProductError>) -> Void) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(.failure(.accountInfo))
                return
            }
            self.colReference = self.database.collection("Dealers/\(id)/Products")
            self.colReference.order(by: "Date", descending: false).getDocuments { querrySnapshot, error in
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
                    let timestamp = product["Date"] as? Timestamp
                    let date = timestamp?.dateValue()
                    let proModel = ProductModel(product["ID"]! as! String, product["Category"]! as! String, product["Name"]! as! String, product["Comment"]! as! String, product["Unit"]! as! String, product["Unit Type"]! as! String, product["Image Url"]! as! String, product["Price"]! as! String, product["Statu"]! as! String, date!)
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
            self.reference = self.database.document("Dealers/\(id)/Products/\(product.id)")
            let data = ["Category" : product.productCategory,
                        "Name" : product.productName,
                        "Comment" : product.productComment,
                        "Unit" : product.productUnit,
                        "Unit Type" : product.productUnitType,
                        "Price" : product.productPrice,
                        "Image Url" : product.productPhoto,
                        "Statu" : product.productStatu,
                        "ID" : product.id,
                        "Date" : product.date] as [String : Any]
            self.reference.setData(data)
            completion(true)
        }
    }
    
    public func deleteProduct(productId: String, completion: @escaping (Bool) -> Void = {_ in }) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(false)
                return
            }
            self.reference = self.database.document("Dealers/\(id)/Products/\(productId)")
            self.reference.delete { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    public func saveStoreImage(imageURL: String) async throws -> Bool {
        let firestoreStorePost: [String : Any] = ["Store Image URL": imageURL]
        getAccountID { email, id in
            let key = email.safeDatabaseKey()
            Task{
            self.reference = self.database.document("Dealers/\(id)/\(key)/Settings")
            try await self.reference.setData(firestoreStorePost, merge: true)
                self.secondReference = self.database.document("Stores/\(id)")
                try await self.secondReference.setData(firestoreStorePost, merge: true)
            }
        }
        return true
    }
    
    public func getStorePhoto(completion: @escaping (Result<String, FetchProductError>) -> Void) {
        getAccountID { email, id in
            let key = email.safeDatabaseKey()
            self.reference = self.database.document("Dealers/\(id)/\(key)/Settings")
            self.reference.getDocument { snapshot, error in
                if snapshot != nil && error == nil {
                    let data = snapshot?.data()
                    if data != nil {
                        completion(.success(data!["Store Image URL"] as! String))
                    } else {
                        completion(.failure(.badUrl))
                    }
                } else {
                    completion(.failure(.noData))
                }
            }
        }
    }
    
    public func saveCustomerSettings(customerSettings: CustomerSettings, completion: @escaping (Bool) -> Void) {
        getAccountID { [self] email, id in
            guard email != "" && id != "" else {
                completion(false)
                return
            }
            let firestoreStorePost: [String : Any] = [
                "Name, Surname": customerSettings.name,
                "Email": email,
                "Phone": customerSettings.phone,
                "Address": customerSettings.address,
                "Address Title": customerSettings.addressTitle,
                "Latitude": customerSettings.customerLatitude,
                "Longitude": customerSettings.customerLongitude,
                "ID": id
            ]
            
            reference = database.document("Customers/\(id)")
            reference.setData(firestoreStorePost, merge: true) { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    public func getCustomerSettings(completion: @escaping (Result<CustomerSettings, FetchProductError>) -> Void) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(.failure(.accountInfo))
                return
            }
            self.reference = self.database.document("Customers/\(id)")
            self.reference.getDocument { snapshot, error in
                guard snapshot != nil && error == nil else {
                    completion(.failure(.noData))
                    return
                }
                let data = snapshot!.data()
                if data != nil {
                    let customer = CustomerSettings(name: data!["Name, Surname"] as! String,
                                                    email: data!["Email"] as! String,
                                                    id: data!["ID"] as! String,
                                                    phone: data!["Phone"] as! String,
                                                    address: data!["Address"] as! String,
                                                    addressTitle: data!["Address Title"] as! String,
                                                    customerLatitude: data!["Latitude"] as! Double,
                                                    customerLongitude: data!["Longitude"] as! Double)
                    completion(.success(customer))
                } else {
                    completion(.failure(.badUrl))
                }
            }
        }
    }
    
    public func getStoresIDs(completion: @escaping (Result<[String], FetchProductError>) -> Void) {
        self.colReference = self.database.collection("Stores")
        self.colReference.getDocuments { querrySnapshot, error in
            guard error == nil else {
                completion(.failure(.badUrl))
                return
            }
            guard let data = querrySnapshot?.documents else {
                completion(.failure(.noData))
                return
            }
            var idArray = [String]()
            for document in data {
                idArray.append(document.documentID)
            }
            completion(.success(idArray))
        }
    }
    
    public func deleteStoreAccount(completion: @escaping (Result<Bool, FetchDeleteError>) -> Void) {
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(.failure(.accountIDError))
                return
            }
            let key = email.safeDatabaseKey()
            self.reference = self.database.document("Users/\(key)")
            self.reference.delete { error in
                guard error == nil else {
                    completion(.failure(.deleteUserError))
                    return
                }
                self.reference = self.database.document("Stores/\(id)")
                self.reference.delete { error in
                    guard error == nil else {
                        completion(.failure(.deleteStoreError))
                        return
                    }
                    StorageManager.shared.deleteAccountStorage(email: email) { success in
                        guard success != true else {
                            completion(.failure(.deleteStorageError))
                            return
                        }
                        AuthManager.shared.deleteUser { success in
                            guard success != true else {
                                completion(.failure(.deleteAuthError))
                                return
                            }
                            completion(.success(true))
                        }
                    }
                }
            }
        }
    }
    
    
    
}
public enum FetchTypeError: Error {
    case noAccountType
}

public enum FetchProductError: Error {
    case accountInfo
    case badUrl
    case noData
    case dataParseError
}

public enum FetchDeleteError: Error {
    case accountIDError
    case deleteUserError
    case deleteStoreError
    case deleteStorageError
    case deleteAuthError
}
