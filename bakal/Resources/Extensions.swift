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

@IBDesignable class TopAlignedLabel: UILabel {
  override func drawText(in rect: CGRect) {
      if let stringText = text {
          let stringTextAsNSString = stringText as NSString
          let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                          options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                  attributes: [NSAttributedString.Key.font: font!],
                                                                          context: nil).size
          super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
      } else {
          super.drawText(in: rect)
      }
  }
  override func prepareForInterfaceBuilder() {
      super.prepareForInterfaceBuilder()
      layer.borderWidth = 1
      layer.borderColor = UIColor.black.cgColor
  }
}


// MARK: Links
/// Default tap gesture recognizer settings for collection view cell
//https://stackoverflow.com/questions/18848725/long-press-gesture-on-uicollectionviewcell
