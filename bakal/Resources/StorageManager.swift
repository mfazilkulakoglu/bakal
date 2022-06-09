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
    
    public func uplooadPhoto(image: UIImage, name: String, completion: @escaping (Result<String, FetchUploadError>) -> Void) {
        DatabaseManager.shared.getAccountID { email, id in
            if email != "" && id != "" {
                let key = email.safeDatabaseKey()
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    let imageReference = self.bucket.child("Dealer/Media/\(key)/\(id)/\(name).jpg")
                    imageReference.putData(imageData, metadata: nil) { metadata, error in
                        if error != nil {
                            completion(.failure(.couldNotUploadImage))
                            print(error?.localizedDescription ?? "Problemm!!!!!!!!")
                        } else {
                            imageReference.downloadURL { url, error in
                                if error == nil || url != nil {
                                    let result = url!.absoluteString
                                    completion(.success(result))
                                } else {
                                    completion(.failure(.downloadError))
                                }
                            }
                        }
                    }
                }
            } else {
                completion(.failure(.noAccountID))
            }
        }
    }
    
    public func downloadStorePhoto(completion: @escaping (Result<String, FetchDownloadError>) -> Void) {
        DatabaseManager.shared.getAccountID { email, id in
            guard email != "" || id != "" else {
                completion(.failure(.noAccountID))
                return
            }
            let key = email.safeDatabaseKey()
            let imageReference = self.bucket.child("Dealer/Media/\(key)/\(id)/StorePhoto.jpg")
            imageReference.downloadURL { url, error in
                if error != nil {
                    completion(.failure(.noImage))
                } else if url == nil {
                    completion(.failure(.noImage))
                } else {
                    let result = url!.absoluteString
                    completion(.success(result))
                }
            }
        }
    }
    
    public func deletePhoto(name: String, completion: @escaping (Bool) -> Void = {_ in }) {
        DatabaseManager.shared.getAccountID { email, id in
            if email != "" && id != "" {
                let key = email.safeDatabaseKey()
                let imageReference = self.bucket.child("Dealer/Media/\(key)/\(id)/\(name).jpg")
                imageReference.delete()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    public func deleteAccountStorage(email: String, completion: @escaping (Bool) -> Void) {
        let key = email.safeDatabaseKey()
        let imageReference = self.bucket.child("Dealer/Media/\(key)")
        imageReference.delete { error in
            guard error != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}

public enum FetchUploadError: Error {
    case noAccountID
    case noImage
    case couldNotUploadImage
    case downloadError
}

public enum FetchDownloadError: Error {
    case noAccountID
    case noImage
    case couldNotDownloadImage
}
