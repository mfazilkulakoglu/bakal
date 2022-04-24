//
//  Models.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

//public enum ProductUnits {
//    case t
//    case kg
//    case g
//    case lt
//    case ml
//    case pcs
//}

public struct StoreModel {
    var email: String
    var id: String
    var storeType: String
    var storeName: String
    var adress: String
    var phone: String
    var minPrice: String
    var maxDistance: String
    var openingTime: String
    var closingTime: String
    var storeLatitude: Double
    var storeLongitude: Double
}

public struct CategoryModel {
    var email: String
    var id: String
    var categoryName: String
}

public class ProductModel: Identifiable, Codable {
    
    var productCategory: String
    var productName: String
    var productComment: String
    var productUnit: String
    var productUnitType: String
    var productPhoto: String
    var productPrice: String
    var productStatu: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case productCategory = "Category Name"
        case productName = "Name"
        case productComment = "Comment"
        case productUnit = "Unit"
        case productUnitType = "Unit type"
        case productPhoto = "Image"
        case productPrice = "Price"
        case productStatu = "Availability"
    }
}

public class ProductMap: Identifiable, Codable {
    
    var proCategory: String
    var proName: String
    var model: ProductModel
    @DocumentID var productID: String? = UUID().uuidString
    
    init(proCategory: String, proName: String, model: ProductModel)
    
    {
        self.proCategory = proCategory
        self.proName = proName
        self.model = model
    }
    
    enum CodingKeys: String, CodingKey {
        case proCategory = "Product Category Name"
        case proName = "Product Name"
        case model = "Product Map"
    }
}



