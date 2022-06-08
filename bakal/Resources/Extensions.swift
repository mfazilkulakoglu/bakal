//
//  Extensions.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit

extension UIView {
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}

extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}

extension UIViewController {
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func initializeHideKeyboard() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}





//        func buyProductAlert(name: String, comment: String, unit: String, unitType: String, price: String, dealerID: String, id: String) {
//            let alert = UIAlertController(title: "\(name)", message: "\(comment)", preferredStyle: .actionSheet)
//            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
//            let addButton = UIAlertAction(title: "Add", style: .default) { action in
//                self.dismiss(animated: true)
//            }
//            alert.addAction(cancelButton)
//            alert.addAction(addButton)
//            self.present(alert, animated: true)
//        }
//    }

//extension NSDictionary {
//    var swiftDictionary: Dictionary<String, [ProductModel]> {
//        var swiftDictionary = Dictionary<String, [ProductModel]>()
//
//        for key : Any in self.allKeys {
//            let stringKey = key as! String
//            if let keyValue = self.value(forKey: stringKey) {
//                swiftDictionary[stringKey] = (keyValue as! [ProductModel])
//            }
//        }
//        return swiftDictionary
//    }
//}

//NotificationCenter.default.post(name: NSNotification.Name("newData") , object: nil)
//NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)


// MARK: Links
/// Default tap gesture recognizer settings for collection view cell
//https://stackoverflow.com/questions/18848725/long-press-gesture-on-uicollectionviewcell
