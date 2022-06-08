//
//  Models.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import Foundation
import UIKit
import MapKit

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
    var storeImageUrl: String
    var storeLatitude: Double
    var storeLongitude: Double
}

public struct CategoryModel {
    var email: String
    var id: String
    var categoryName: String
}

public struct ProductModel: Codable, Hashable, Equatable {

    var id: String
    var productCategory: String
    var productName: String
    var productComment: String
    var productUnit: String
    var productUnitType: String
    var productPhoto: String
    var productPrice: String
    var productStatu: String
    var date: Date
    var storeName: String
    var storeID: String
    
    init(_ id: String, _ productCategory: String, _ productName: String, _ productComment: String, _ productUnit: String, _ productUnitType: String, _ productPhoto: String, _ productPrice: String, _ productStatu: String, _ date: Date, _ storeName: String, _ storeID: String)

    {
        self.id = id
        self.productCategory = productCategory
        self.productName = productName
        self.productComment = productComment
        self.productUnit = productUnit
        self.productUnitType = productUnitType
        self.productPhoto = productPhoto
        self.productPrice = productPrice
        self.productStatu = productStatu
        self.date = date
        self.storeName = storeName
        self.storeID = storeID
        
    }
    
     enum CodingKeys : String, CodingKey {
        case id = "ID"
        case productCategory = "Category"
        case productName = "Name"
        case productComment = "Comment"
        case productUnit = "Unit"
        case productUnitType = "Unit Type"
        case productPhoto = "Image Url"
        case productPrice = "Price"
        case productStatu = "Statu"
        case date = "Date"
        case storeName = "Store Name"
        case storeID = "Store ID"
    }
}

public struct CustomerSettings {
    var name: String
    var email: String
    var id: String
    var phone: String
    var address: String
    var addressTitle: String
    var customerLatitude: Double
    var customerLongitude: Double
}

public class StoreAnnotation: MKPointAnnotation {
    var storeModel: StoreModel?
}

public struct ChosenProduct {
    var name: String
    var unit: String
    var unitType: String
    var price: String
    var priceType: String
    var id: String
    var dealerID: String
    var storeName: String
}

public struct OrderInfos {
    var statu: String
    var date: Date
    var orderID: String
    var customerID: String
    var dealerID: String
    var comment: String
    var totalCost: String
    var storeName: String
}

public struct GivenOrder {
    var products: [ChosenProduct]
    var orderInfo: OrderInfos
}
