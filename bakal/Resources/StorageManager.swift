//
//  StorageManager.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import FirebaseStorage
import UIKit

public class StorageManager {
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public func uplooadModelPhoto(image: UIImage, completion: ((String?) -> Void)? = nil) {
        DatabaseManager.shared.getAccountID { email, id in
            if email != "" && id != "" {
                let uuid = UUID().uuidString
                let key = email.safeDatabaseKey()
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    let imageReference = self.bucket.child("Dealer/Media/\(key)/\(id)/\(uuid).jpg")
                    imageReference.putData(imageData, metadata: nil) { metadata, error in
                        if error != nil {
                            completion!(nil)
                        } else {
                            imageReference.downloadURL { url, error in
                                if error == nil {
                                    let result = url?.absoluteString
                                    completion!(result)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
