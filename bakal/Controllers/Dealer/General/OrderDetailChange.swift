//
//  OrderDetail.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 5.06.2022.
//

import Foundation
import UIKit

public class OrderDetailChange: UIView, UITableViewDelegate, UITableViewDataSource {
    
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
        return label
    }()
    
    public let statuButton: UIButton = {
        let label = UIButton()
        label.setTitle("Preparing", for: .normal)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12.0
        label.setTitleColor(.white, for: .normal)
        label.backgroundColor = .systemGreen
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
    
    public let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Cost:"
        label.textAlignment = .left
        return label
    }()
    
    private let priceTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "€"
        label.textAlignment = .left
        return label
    }()
    
    public let totalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    public let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date:"
        label.textAlignment = .left
        return label
    }()
    
    public let dateTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    public let commentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    public let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    public var model: GivenOrder?
    private var id: String?
    private var myTargetView: UIView?
    private let mapDetail = ShowMap()
    private var viewController: UIViewController?
    
    func showAlert(with model: GivenOrder, on viewController: UIViewController) {
        
        guard let targetView = viewController.view else {
            return
        }
        self.model = model
        self.myTargetView = targetView
        self.viewController = viewController
        detailView.frame = CGRect(x: -targetView.width,
                                  y: 100,
                                  width: targetView.width - 80,
                                  height: targetView.height - 200)
        titleLabel.frame = CGRect(x: 5,
                                  y: 5,
                                  width: detailView.width - 10,
                                  height: 80)
        statuButton.frame = CGRect(x: 5,
                                  y: titleLabel.bottom + 10,
                                  width: detailView.width - 10,
                                  height: 40)
        okButton.frame = CGRect(x: 5,
                                y: detailView.height - 45,
                                width: detailView.width - 10,
                                height: 40)
        priceLabel.frame = CGRect(x: 5,
                                  y: okButton.top - 50,
                                  width: 100,
                                  height: 40)
        priceTypeLabel.frame = CGRect(x: detailView.width - 20,
                                      y: priceLabel.top,
                                      width: 15,
                                      height: 40)
        totalLabel.frame = CGRect(x: priceLabel.right + 5,
                                  y: priceLabel.top,
                                  width: priceTypeLabel.left - (priceLabel.right + 10),
                                  height: 40)
        dateLabel.frame = CGRect(x: 5,
                                 y: priceLabel.top - 50,
                                 width: 60,
                                 height: 40)
        dateTextLabel.frame = CGRect(x: dateLabel.right + 5,
                                     y: dateLabel.top,
                                     width: detailView.width - dateLabel.right - 10,
                                     height: 40)
        commentLabel.frame = CGRect(x: 5,
                                    y: dateLabel.top - 50,
                                    width: detailView.width - 10,
                                    height: 40)
        tableView.frame = CGRect(x: 5,
                                 y: statuButton.bottom + 10,
                                 width: detailView.width - 10,
                                 height: commentLabel.top - statuButton.bottom - 20)
        
        DispatchQueue.main.async { [self] in
            
            backgroundView.frame = targetView.bounds
            targetView.addSubview(backgroundView)
            targetView.addSubview(detailView)
            detailView.addSubview(titleLabel)
            detailView.addSubview(statuButton)
            detailView.addSubview(okButton)
            detailView.addSubview(priceLabel)
            detailView.addSubview(priceTypeLabel)
            detailView.addSubview(totalLabel)
            detailView.addSubview(dateLabel)
            detailView.addSubview(dateTextLabel)
            detailView.addSubview(commentLabel)
            detailView.addSubview(tableView)
            
            titleLabel.text = "\(model.orderInfo.storeName)"
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "HelveticaNeue",
                                     size: 33.0)
                 
            if self.model!.orderInfo.statu == "On the Way" {
                statuButton.setTitle("On the Way", for: .normal)
                statuButton.backgroundColor = .systemOrange
            } else if self.model!.orderInfo.statu == "Delivered" {
                statuButton.setTitle("Delivered", for: .normal)
                statuButton.backgroundColor = .darkGray
            } else {
                statuButton.setTitle("Preparing", for: .normal)
                statuButton.backgroundColor = .systemGreen
            }
            
            okButton.addTarget(self,
                               action: #selector(dismissAlert),
                               for: .touchUpInside)
            statuButton.addTarget(self,
                                  action: #selector(changeStatu),
                                  for: .touchUpInside)
            
            totalLabel.text = model.orderInfo.totalCost
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dateTextLabel.text = formatter.string(from: model.orderInfo.date)
            
            commentLabel.text = model.orderInfo.comment
            
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
            tableView.reloadData()
            
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
    
    @objc func changeStatu() {
        let statuTitle = statuButton.title(for: .normal)
        switch statuTitle {
        case ("Preparing"):
            DatabaseManager.shared.changeOrderStatu(givenOrder: model!,
                                                    statu: "On the Way") { success in
                if success {
                    self.statuButton.setTitle("On the Way", for: .normal)
                    self.statuButton.backgroundColor = .systemOrange
                }
            }
        case ("On the Way"):
            DatabaseManager.shared.changeOrderStatu(givenOrder: model!,
                                                    statu: "Delivered") { success in
                if success {
                    self.statuButton.setTitle("Delivered", for: .normal)
                    self.statuButton.backgroundColor = .darkGray
                }
            }
        default:
            statuButton.isEnabled = false
        }
    }
    
    @objc func dismissAlert() {
        
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.detailView.frame = CGRect(x: -targetView.width,
                                           y: 100,
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
                        
                        mapDetail.showAlert(with: self.model!, on: viewController.self!)
                    }
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model!.products.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
        cell.configure(with: self.model!.products[indexPath.row])
        return cell
    }
}
