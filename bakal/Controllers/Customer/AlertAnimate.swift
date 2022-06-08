//
//  AlertAnimate.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 27.05.2022.
//

import Foundation
import UIKit

public class AddProductAlert {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .secondarySystemBackground
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12.0
        return alert
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    
    private let commentLabel: UILabel = {
        let commentLabel = UILabel()
        return commentLabel
    }()
    
    public let unitLabel: UILabel = {
        let unitLabel = UILabel()
        return unitLabel
    }()
    
    public let unitText: UITextField = {
        let unitText = UITextField()
        unitText.placeholder = "Type unit you want"
        unitText.leftViewMode = .always
        unitText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 0))
        unitText.layer.masksToBounds = true
        unitText.layer.cornerRadius = 8.0
        unitText.layer.borderWidth = 1
        unitText.layer.borderColor = UIColor.lightGray.cgColor
        unitText.backgroundColor = .systemBackground
        unitText.autocorrectionType = .no
        unitText.autocapitalizationType = .none
        unitText.keyboardType = .decimalPad
        return unitText
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = "Price:"
        priceLabel.textAlignment = .left
        return priceLabel
    }()
    
    private let priceTypeLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = "€"
        priceLabel.textAlignment = .left
        return priceLabel
    }()
    
    public let totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.textAlignment = .right
        return totalLabel
    }()
    
    private let dismissButton: UIButton = {
        let dismissButton = UIButton()
        dismissButton.layer.masksToBounds = true
        dismissButton.layer.cornerRadius = 12.0
        dismissButton.setTitle("Cancel", for: .normal)
        dismissButton.backgroundColor = .systemRed
        dismissButton.setTitleColor(.white, for: .normal)
        return dismissButton
    }()
    
    public let addButton: UIButton = {
        let addButton = UIButton()
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 12.0
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = .systemBackground
        addButton.setTitleColor(.secondarySystemBackground, for: .normal)
        addButton.isEnabled = false
        return addButton
    }()
    
    public var model: ProductModel?
    
    private var id: String?
    
    private var myTargetView: UIView?
    
    func showAlert(with model: ProductModel,
                   id: String,
                   on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        self.model = model
        self.id = id
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 40,
                                 y: -300,
                                 width: targetView.width - 80,
                                 height: 300)
        targetView.addSubview(alertView)
        
        titleLabel.frame = CGRect(x: 5,
                                  y: 5,
                                  width: alertView.width - 10,
                                  height: 80)
        titleLabel.text = "\(model.productName) (\(model.productUnitType))"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue",
                                 size: 33.0)
        alertView.addSubview(titleLabel)
        
        commentLabel.frame = CGRect(x: 5,
                                    y: titleLabel.bottom + 10,
                                    width: alertView.width - 10,
                                    height: 40)
        commentLabel.text = model.productComment
        commentLabel.textAlignment = .left
        alertView.addSubview(commentLabel)
        
        unitLabel.frame = CGRect(x: 5,
                                 y: commentLabel.bottom + 5,
                                 width: 50,
                                 height: 40)
        unitLabel.text = model.productUnitType
        unitLabel.textAlignment = .left
        alertView.addSubview(unitLabel)
        
        unitText.frame = CGRect(x: unitLabel.right + 5,
                                y: unitLabel.top,
                                width: alertView.width - (unitLabel.width + 15),
                                height: 40)
        alertView.addSubview(unitText)
        
        
        priceLabel.frame = CGRect(x: 5,
                                  y: unitLabel.bottom + 10,
                                  width: 60,
                                  height: 40)
        alertView.addSubview(priceLabel)
        
        priceTypeLabel.frame = CGRect(x: alertView.width - 20,
                                      y: unitLabel.bottom + 10,
                                      width: 15,
                                      height: 40)
        alertView.addSubview(priceTypeLabel)
        
        totalLabel.frame = CGRect(x: priceLabel.right + 5,
                                  y: unitLabel.bottom + 10,
                                  width: priceTypeLabel.left - (priceLabel.width + 15),
                                  height: 40)
        totalLabel.text = "\(Double(model.productPrice)! * (Double(unitText.text ?? "0.0") ?? 0.0))"
        alertView.addSubview(totalLabel)
        
        
        
        
        dismissButton.frame = CGRect(x: 5,
                                     y: alertView.height - 45,
                                     width: (alertView.width - 15) / 2,
                                     height: 40)
        dismissButton.addTarget(self,
                                action: #selector(dismissAlert),
                                for: .touchUpInside)
        alertView.addSubview(dismissButton)
        
        addButton.frame = CGRect(x: dismissButton.right + 5,
                                 y: alertView.height - 45,
                                 width: (alertView.width - 15) / 2,
                                 height: 40)
        
        addButton.addTarget(self,
                            action: #selector(tappedAddButton),
                            for: .touchUpInside)
        alertView.addSubview(addButton)
        
        
        
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }) { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = targetView.center
                })
            }
        }
    }
    
    @objc func tappedAddButton() {
        
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.height,
                                          width: targetView.width - 80,
                                          height: 300)
        }) { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                }) { done in
                    if done {
                        
                        DispatchQueue.main.async { [self] in
                            let orderedProduct = ChosenProduct(name: model!.productName,
                                                               unit: self.unitText.text!,
                                                               unitType: model!.productUnitType,
                                                               price: totalLabel.text!,
                                                               priceType: "€",
                                                               id: model!.id,
                                                               dealerID: id!,
                                                               storeName: model!.storeName)
                            
                            guard let index = NewOrderVC.chosenProducts.firstIndex(where: {
                                $0.id == orderedProduct.id }) else {
                                NewOrderVC.chosenProducts.append(orderedProduct)
                                return
                            }
                            NewOrderVC.chosenProducts[index].unit = String((Double(NewOrderVC.chosenProducts[index].unit) ?? 0.0) + Double(orderedProduct.unit)!)
                            NewOrderVC.chosenProducts[index].price = String((Double(NewOrderVC.chosenProducts[index].price) ?? 0.0) + Double(orderedProduct.price)!)
                            
                            self.alertView.removeFromSuperview()
                            self.backgroundView.removeFromSuperview()
                            self.unitText.text = nil
                            self.addButton.backgroundColor = .systemBackground
                            self.addButton.setTitleColor(.secondarySystemBackground, for: .normal)
                            self.addButton.isEnabled = false
                        }
                    }
                }
            }
        }
    }
    
    @objc func dismissAlert() {
        
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.height,
                                          width: targetView.width - 80,
                                          height: 300)
        }) { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                }) { [self] done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.unitText.text = nil
                        self.addButton.backgroundColor = .systemBackground
                        self.addButton.setTitleColor(.secondarySystemBackground, for: .normal)
                        self.addButton.isEnabled = false
                        
                    }
                }
            }
        }
    }
}

