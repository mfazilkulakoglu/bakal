//
//  Models.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import Foundation
import UIKit

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
    
    init(_ id: String, _ productCategory: String, _ productName: String, _ productComment: String, _ productUnit: String, _ productUnitType: String, _ productPhoto: String, _ productPrice: String, _ productStatu: String, _ date: Date)

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
