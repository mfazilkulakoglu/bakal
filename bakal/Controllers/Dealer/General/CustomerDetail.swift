//
//  OrderDetail.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 5.06.2022.
//

import Foundation
import UIKit

public class CustomerDetail: UIView {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let detailView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .secondarySystemBackground
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12.0
        return alert
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 33.0)
        label.textAlignment = .center
        return label
    }()
    
    public let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "verdana", size: 17.0)
        label.textAlignment = .left
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12.0
        button.setTitle("OK", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "verdana", size: 13.0)
        label.text = "Name:"
        label.textAlignment = .left
        return label
    }()
    
    public let nameTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "verdana", size: 13.0)
        label.textAlignment = .left
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "verdana", size: 13.0)
        label.text = "Address:"
        label.textAlignment = .left
        return label
    }()
    
    public let addressTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "verdana", size: 13.0)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    public let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "verdana", size: 13.0)
        label.text = "Phone:"
        label.textAlignment = .left
        return label
    }()
    
    public let phoneTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "verdana", size: 13.0)
        label.textAlignment = .left
        return label
    }()
    
    public let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Comment:"
        label.font = UIFont(name: "verdana", size: 13.0)
        label.textAlignment = .left
        return label
    }()
    
    private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "verdana", size: 13.0)
        return label
    }()
    
    public var order: GivenOrder?
    private var customer: CustomerSettings?
    private var myTargetView: UIView?
    
    func showAlert(with order: GivenOrder, customer: CustomerSettings, on viewController: UIViewController) {
        
        guard let targetView = viewController.view else {
            return
        }
        self.order = order
        self.customer = customer
        self.myTargetView = targetView
        
        detailView.frame = CGRect(x: 40,
                                  y: -targetView.height,
                                  width: targetView.width - 80,
                                  height: targetView.height - 200)
        titleLabel.frame = CGRect(x: 5,
                                  y: 5,
                                  width: detailView.width - 10,
                                  height: 80)
        dateLabel.frame = CGRect(x: 15,
                                 y: titleLabel.bottom + 5,
                                 width: detailView.width - 30,
                                 height: 40)
        nameLabel.frame = CGRect(x: 5,
                                 y: dateLabel.bottom + 5,
                                 width: 80,
                                 height: 25)
        nameTextLabel.frame = CGRect(x: nameLabel.right + 5,
                                     y: nameLabel.top,
                                     width: detailView.width - (nameLabel.right + 10),
                                     height: 25)
        phoneLabel.frame = CGRect(x: 5,
                                  y: nameLabel.bottom + 5,
                                  width: 80,
                                  height: 25)
        phoneTextLabel.frame = CGRect(x: phoneLabel.right + 5,
                                      y: phoneLabel.top,
                                      width: detailView.width - (phoneLabel.right + 10),
                                      height: 25)
        addressLabel.frame = CGRect(x: 5,
                                    y: phoneLabel.bottom + 5,
                                    width: 80,
                                    height: 25)
        addressTextLabel.frame = CGRect(x: addressLabel.right + 5,
                                        y: addressLabel.top,
                                        width: detailView.width - (addressLabel.right + 10),
                                        height: 50)
        okButton.frame = CGRect(x: 5,
                                y: detailView.height - 45,
                                width: detailView.width - 10,
                                height: 40)
        commentLabel.frame = CGRect(x: 5,
                                    y: addressTextLabel.bottom + 5,
                                    width: 80,
                                    height: 25)
        commentTextLabel.frame  = CGRect(x: commentLabel.right + 5,
                                         y: commentLabel.top,
                                         width: detailView.width - (commentLabel.right + 10),
                                         height: 100)
        commentTextLabel.drawText(in: CGRect(x: commentLabel.right + 5,
                                             y: commentLabel.top,
                                             width: detailView.width - (commentLabel.right + 10),
                                             height: 100))
        
        
        DispatchQueue.main.async { [self] in
            
            backgroundView.frame = targetView.bounds
            
            targetView.addSubview(backgroundView)
            targetView.addSubview(detailView)
            
            detailView.addSubview(titleLabel)
            detailView.addSubview(nameLabel)
            detailView.addSubview(nameTextLabel)
            detailView.addSubview(dateLabel)
            detailView.addSubview(phoneLabel)
            detailView.addSubview(phoneTextLabel)
            detailView.addSubview(addressLabel)
            detailView.addSubview(addressTextLabel)
            detailView.addSubview(okButton)
            detailView.addSubview(commentLabel)
            detailView.addSubview(commentTextLabel)
            
            titleLabel.text = "\(customer.addressTitle)"
            
            nameTextLabel.text = customer.name
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dateLabel.text = formatter.string(from: order.orderInfo.date)
            
            phoneTextLabel.text = customer.phone
            
            addressTextLabel.text = customer.address
            
            commentTextLabel.text = order.orderInfo.comment
            
            okButton.addTarget(self,
                               action: #selector(dismissAlert),
                               for: .touchUpInside)
            
            UIView.animate(withDuration: 0.25,
                           animations: {
                self.backgroundView.alpha = Constants.backgroundAlphaTo
            }) { done in
                if done {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.detailView.center = targetView.center
                    })
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
            self.detailView.frame = CGRect(x: 40,
                                           y: -targetView.height,
                                           width: targetView.width - 80,
                                           height: targetView.height - 200)
        }) { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                }) { [self] done in
                    if done {
                        self.detailView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        
                    }
                }
            }
        }
    }
    
    
}
