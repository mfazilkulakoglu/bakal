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
    private let secondDatabase = Firestore.firestore()
    private var reference: DocumentReference!
    private var secondReference: DocumentReference!
    private var thirdReference: DocumentReference!
    private var fourthReference: DocumentReference!
    private var fifthReference: DocumentReference!
    private var sixthReference: DocumentReference!
    private var colReference: CollectionReference!
    private var secondColReference: CollectionReference!
    
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
                    let proModel = ProductModel(product["ID"]! as! String,
                                                product["Category"]! as! String,
                                                product["Name"]! as! String,
                                                product["Comment"]! as! String,
                                                product["Unit"]! as! String,
                                                product["Unit Type"]! as! String,
                                                product["Image Url"]! as! String,
                                                product["Price"]! as! String,
                                                product["Statu"]! as! String,
                                                date!,
                                                product["Store Name"]! as! String,
                                                product["Store ID"]! as! String)
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
        getSettings { store in
            switch store {
            case .failure(_):
                completion(false)
            case .success(let storeSettings):
                self.reference = self.database.document("Dealers/\(storeSettings.id)/Products/\(product.id)")
                let data = ["Category" : product.productCategory,
                            "Name" : product.productName,
                            "Comment" : product.productComment,
                            "Unit" : product.productUnit,
                            "Unit Type" : product.productUnitType,
                            "Price" : product.productPrice,
                            "Image Url" : product.productPhoto,
                            "Statu" : product.productStatu,
                            "ID" : product.id,
                            "Date" : product.date,
                            "Store Name" : storeSettings.storeName,
                            "Store ID" : storeSettings.id] as [String : Any]
                self.reference.setData(data, merge: true)
                completion(true)
            }
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
    
    public func deleteStoreAccount(completion: @escaping (Result<Bool, FetchDeleteError>) -> Void) {
        let batch = self.database.batch()
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(.failure(.accountIDError))
                return
            }
            let key = email.safeDatabaseKey()
            self.reference = self.database.document("Users/\(key)")
            self.secondReference = self.database.document("Stores/\(id)")
            self.thirdReference = self.database.document("Orders/\(id)")
            self.fourthReference = self.database.document("Dealers/\(id)")
            self.fifthReference = self.database.document("DealerOrders/\(id)")
            batch.deleteDocument(self.reference)
            batch.deleteDocument(self.secondReference)
            batch.deleteDocument(self.thirdReference)
            batch.deleteDocument(self.fourthReference)
            batch.deleteDocument(self.fifthReference)
            
            batch.commit { error in
                if error != nil {
                    completion(.failure(.deleteStoreError))
                } else {
                    StorageManager.shared.deleteAccountStorage(email: email) { success in
                        guard success == true else {
                            completion(.failure(.deleteStorageError))
                            return
                        }
                        AuthManager.shared.deleteUser { success in
                            guard success == true else {
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
    
    public func deleteCustomerAccount(completion: @escaping (Result<Bool, FetchDeleteError>) -> Void) {
        let batch = self.database.batch()
        getAccountID { email, id in
            guard email != "" && id != "" else {
                completion(.failure(.accountIDError))
                return
            }
            let key = email.safeDatabaseKey()
            self.reference = self.database.document("Users/\(key)")
            self.secondReference = self.database.document("Customers/\(id)")
            self.thirdReference = self.database.document("Orders/\(id)")
            self.fifthReference = self.database.document("CustomerOrders/\(id)")
            batch.deleteDocument(self.reference)
            batch.deleteDocument(self.secondReference)
            batch.deleteDocument(self.thirdReference)
            batch.deleteDocument(self.fifthReference)
            
            batch.commit { error in
                if error != nil {
                    completion(.failure(.deleteStoreError))
                } else {
                    AuthManager.shared.deleteUser { success in
                        guard success == true else {
                            completion(.failure(.deleteAuthError))
                            return
                        }
                        completion(.success(true))
                        
                    }
                }
            }
        }
    }
    
    public func getStores(completion: @escaping (Result<[StoreModel], FetchDownloadStoreError>) -> Void) {
        self.colReference = database.collection("Stores")
        self.colReference.getDocuments { querrySnapshot, error in
            guard error == nil else {
                completion(.failure(.badURL))
                return
            }
            guard querrySnapshot != nil else {
                completion(.failure(.noData))
                return
            }
            var stores = [StoreModel]()
            guard let data = querrySnapshot?.documents else {
                completion(.failure(.parseError))
                return
            }
            for document in data {
                let storeData = document.data()
                let storeModel = StoreModel(email: storeData["Email"]! as! String,
                                            id: storeData["ID"]! as! String,
                                            storeType: storeData["Store Type"]! as! String,
                                            storeName: storeData["Store Name"]! as! String,
                                            adress: storeData["Address"]! as! String,
                                            phone: storeData["Phone"]! as! String,
                                            minPrice: storeData["Minimum Price"]! as! String,
                                            maxDistance: storeData["Maximum Distance"]! as! String,
                                            openingTime: storeData["Opening Time"]! as! String,
                                            closingTime: storeData["Closing Time"]! as! String,
                                            storeImageUrl: storeData["Store Image URL"]! as! String,
                                            storeLatitude: storeData["Latitude"]! as! Double,
                                            storeLongitude: storeData["Longitude"]! as! Double)
                stores.append(storeModel)
            }
            completion(.success(stores))
        }
    }
    
    public func showProducts(id: String, completion: @escaping (Result<[String : [ProductModel]], FetchProductError>) -> Void) {
        
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
                let proModel = ProductModel(product["ID"]! as! String,
                                            product["Category"]! as! String,
                                            product["Name"]! as! String,
                                            product["Comment"]! as! String,
                                            product["Unit"]! as! String,
                                            product["Unit Type"]! as! String,
                                            product["Image Url"]! as! String,
                                            product["Price"]! as! String,
                                            product["Statu"]! as! String,
                                            date!,
                                            product["Store Name"]! as! String,
                                            product["Store ID"]! as! String)
                if result[proModel.productCategory] != nil {
                    result[proModel.productCategory]?.append(proModel)
                } else {
                    result[proModel.productCategory] = [proModel]
                }
                
            }
            completion(.success(result))
        }
    }
    
    public func giveOrder(description: String, total: String, orderModel: [ChosenProduct], completion: @escaping (Bool) -> Void) {
        
        getAccountID { email, customerID in
            let dealerID = orderModel[0].dealerID
            let storeName = orderModel[0].storeName
            let orderID = UUID().uuidString
            let batch = self.database.batch()
            
            let orderInfo: [String : Any] = ["Date": Date.now,
                                             "Dealer ID": dealerID,
                                             "Customer ID": customerID,
                                             "Statu": "Preparing",
                                             "Order ID": orderID,
                                             "Description": description,
                                             "Total Cost": total,
                                             "Store Name" : storeName]
            
            self.reference = self.database.document("CustomerOrders/\(customerID)/Orders/\(orderID)")
            batch.setData(orderInfo, forDocument: self.reference)
            self.thirdReference = self.database.document("DealerOrders/\(dealerID)/Orders/\(orderID)")
            batch.setData(orderInfo, forDocument: self.thirdReference)
            
            
            for product in orderModel {
                let orderPost: [String : Any] = ["Name" : product.name,
                                                 "Store Name" : product.storeName,
                                                 "Unit": product.unit,
                                                 "Unit Type": product.unitType,
                                                 "Price": product.price,
                                                 "Price Type": product.priceType,
                                                 "Product ID": product.id,
                                                 "Dealer ID": product.dealerID]
                self.secondReference = self.database.document("Orders/\(customerID)/\(orderID)/\(product.id)")
                batch.setData(orderPost, forDocument: self.secondReference)
            }
            
            for product in orderModel {
                let orderPost: [String : Any] = ["Name" : product.name,
                                                 "Store Name" : product.storeName,
                                                 "Unit": product.unit,
                                                 "Unit Type": product.unitType,
                                                 "Price": product.price,
                                                 "Price Type": product.priceType,
                                                 "Product ID": product.id,
                                                 "Customer ID": customerID]
                self.fourthReference = self.database.document("Orders/\(dealerID)/\(orderID)/\(product.id)")
                batch.setData(orderPost, forDocument: self.fourthReference)
                
            }
            
            batch.commit { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    public func getOrderInfosToCustomer(completion: @escaping (Result<[OrderInfos], FetchDownloadOrdersError>) -> Void) {
        getAccountID { email, customerID in
            guard email != "" && customerID != "" else {
                completion(.failure(.noAccountData))
                return
            }
            self.colReference = self.database.collection("CustomerOrders/\(customerID)/Orders")
            self.colReference.order(by: "Date", descending: true).getDocuments { querrySnapshot, error in
                guard error == nil else {
                    completion(.failure(.badURL))
                    return
                }
                guard let data = querrySnapshot?.documents else {
                    completion(.failure(.noOrderIDs))
                    return
                }
                var infos = [OrderInfos]()
                for document in data {
                    let getOrderInfo = document.data()
                    var comment = getOrderInfo["Description"] as! String
                    if comment == "" {
                        comment = "No comment"
                    }
                    
                    let timeStamp = getOrderInfo["Date"] as? Timestamp
                    let date = timeStamp?.dateValue()
                    let info = OrderInfos(statu: getOrderInfo["Statu"]! as! String,
                                          date: date!,
                                          orderID: getOrderInfo["Order ID"]! as! String,
                                          customerID: getOrderInfo["Customer ID"]! as! String,
                                          dealerID: getOrderInfo["Dealer ID"]! as! String,
                                          comment: comment,
                                          totalCost: getOrderInfo["Total Cost"]! as! String,
                                          storeName: getOrderInfo["Store Name"]! as! String)
                    infos.append(info)
                }
                completion(.success(infos))
            }
        }
    }
    
    public func getOrderToCustomer(info: OrderInfos, completion: @escaping (Result<[ChosenProduct], FetchDownloadOrdersError>) -> Void) {
        
        var products = [ChosenProduct]()
        
        self.secondColReference = self.secondDatabase.collection("Orders/\(info.customerID)/\(info.orderID)")
        self.secondColReference.getDocuments { querrySnapshot, error in
            guard error == nil else {
                completion(.failure(.parseError))
                return
            }
            guard querrySnapshot != nil else {
                completion(.failure(.noData))
                return
            }
            let documents = querrySnapshot!.documents
            for document in documents {
                let data = document.data()
                let product = ChosenProduct(name: data["Name"]! as! String,
                                            unit: data["Unit"]! as! String,
                                            unitType: data["Unit Type"]! as! String,
                                            price: data["Price"]! as! String,
                                            priceType: data["Price Type"]! as! String,
                                            id: data["Product ID"]! as! String,
                                            dealerID: data["Dealer ID"]! as! String,
                                            storeName: data["Store Name"]! as! String)
                products.append(product)
            }
            completion(.success(products))
        }
    }
    
    public func getStoreSettings(storeID: String, completion: @escaping (Result<StoreModel, FetchProductError>) -> Void) {
            self.reference = self.database.document("Stores/\(storeID)")
            self.reference.getDocument { snapshot, error in
                guard snapshot != nil && error == nil else {
                    completion(.failure(.noData))
                    return
                }
                let data = snapshot!.data()
                if data != nil {
                    let storeModel = StoreModel(email: data!["Email"] as! String,
                                                id: data!["ID"] as! String,
                                                storeType: data!["Store Type"] as! String,
                                                storeName: data!["Store Name"] as! String,
                                                adress: data!["Address"] as! String,
                                                phone: data!["Phone"] as! String,
                                                minPrice: data!["Minimum Price"] as! String,
                                                maxDistance: data!["Maximum Distance"] as! String,
                                                openingTime: data!["Opening Time"] as! String,
                                                closingTime: data!["Closing Time"] as! String,
                                                storeImageUrl: data!["Store Image URL"] as! String,
                                                storeLatitude: data!["Latitude"] as! Double,
                                                storeLongitude: data!["Longitude"] as! Double) as! StoreModel
                    completion(.success(storeModel))
                } else {
                    completion(.failure(.badUrl))
                }
            }
        
    }
    
    public func getOrderInfosToDealer(completion: @escaping (Result<[OrderInfos], FetchDownloadOrdersError>) -> Void) {
        getAccountID { email, dealerID in
            guard email != "" && dealerID != "" else {
                completion(.failure(.noAccountData))
                return
            }
            self.colReference = self.database.collection("DealerOrders/\(dealerID)/Orders")
            self.colReference.order(by: "Date", descending: true).getDocuments { querrySnapshot, error in
                guard error == nil else {
                    completion(.failure(.badURL))
                    return
                }
                guard let data = querrySnapshot?.documents else {
                    completion(.failure(.noOrderIDs))
                    return
                }
                var infos = [OrderInfos]()
                for document in data {
                    let getOrderInfo = document.data()
                    var comment = getOrderInfo["Description"] as! String
                    if comment == "" {
                        comment = "No comment"
                    }
                    
                    let timeStamp = getOrderInfo["Date"] as? Timestamp
                    let date = timeStamp?.dateValue()
                    let info = OrderInfos(statu: getOrderInfo["Statu"]! as! String,
                                          date: date!,
                                          orderID: getOrderInfo["Order ID"]! as! String,
                                          customerID: getOrderInfo["Customer ID"]! as! String,
                                          dealerID: getOrderInfo["Dealer ID"]! as! String,
                                          comment: comment,
                                          totalCost: getOrderInfo["Total Cost"]! as! String,
                                          storeName: getOrderInfo["Store Name"]! as! String)
                    infos.append(info)
                }
                completion(.success(infos))
            }
        }
    }
    
    public func changeOrderStatu(givenOrder: GivenOrder, statu: String, completion: @escaping (Bool) -> Void) {
        let batch = self.database.batch()
        let statuPost: [String : Any] = ["Statu" : statu]
        self.reference = self.database.document("CustomerOrders/\(givenOrder.orderInfo.customerID)/Orders/\(givenOrder.orderInfo.orderID)")
        self.thirdReference = self.database.document("DealerOrders/\(givenOrder.orderInfo.dealerID)/Orders/\(givenOrder.orderInfo.orderID)")
        batch.updateData(statuPost, forDocument: self.reference)
        batch.updateData(statuPost, forDocument: self.thirdReference)
        
        batch.commit { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    public enum FetchDownloadOrdersError: Error {
        case noAccountData
        case noData
        case badURL
        case parseError
        case orderIDError
        case noOrderIDs
    }
    
    public enum FetchDownloadStoreError: Error {
        case noData
        case badURL
        case parseError
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
    
    public enum SaveError: Error {
        case accountIDError
        case fireStoreError
    }
}
