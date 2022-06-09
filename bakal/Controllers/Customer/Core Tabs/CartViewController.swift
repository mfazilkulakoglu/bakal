//
//  FavoritesViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var customerID = String()
    private var dealerID = String()
    private var totalCost: Double = 0.0
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("BUY", for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.secondarySystemBackground, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12.0
        button.isEnabled = false
        return button
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12.0
        return label
    }()
    
    private let priceType: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12.0
        return label
    }()
    
    private let commentText: UITextField = {
        let field = UITextField()
        field.placeholder = "You can add comment in here"
        field.textAlignment = .left
        return field
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        buyButton.frame = CGRect(x: view.width / 4,
                                 y: view.height - (tabBarHeight + 50),
                                 width: view.width / 2,
                                 height: 40)
        totalLabel.frame = CGRect(x: view.width / 4,
                                  y: buyButton.top - 50,
                                  width: view.width / 2,
                                  height: 40)
        priceType.frame = CGRect(x: totalLabel.right + 5,
                                 y: totalLabel.top,
                                 width: 15,
                                 height: 40)
        commentText.frame = CGRect(x: 5,
                                   y: totalLabel.top - 85,
                                   width: view.width - 10,
                                   height: 80)
        tableView.frame = CGRect(x: 0,
                                 y: tabBarHeight,
                                 width: view.width,
                                 height: commentText.top - (tabBarHeight + 10))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        view.addSubview(buyButton)
        view.addSubview(totalLabel)
        view.addSubview(tableView)
        view.addSubview(priceType)
        view.addSubview(commentText)
        
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
            for cost in NewOrderVC.chosenProducts {
                let x = Double(cost.price)
                self.totalCost = totalCost + x!
            }
            if totalCost != 0.0 {
                totalLabel.text = String(totalCost)
                priceType.text = "€"
                buyButton.backgroundColor = .systemGreen
                buyButton.setTitleColor(.white, for: .normal)
                buyButton.isEnabled = true
            }
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self,
                           forCellReuseIdentifier: CartTableViewCell.identifier)
        buyButton.addTarget(self,
                            action: #selector(tappedBuyButton),
                            for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
            self.totalCost = 0.0
            for cost in NewOrderVC.chosenProducts {
                
                let x = Double(cost.price)
                self.totalCost = totalCost + x!
            }
            if totalCost != 0.0 {
                totalLabel.text = String(totalCost)
                priceType.text = "€"
                buyButton.backgroundColor = .systemGreen
                buyButton.setTitleColor(.white, for: .normal)
                buyButton.isEnabled = true
            }
        }
    }
    
    @objc func tappedBuyButton() {
        let comment = commentText.text
        let total = totalLabel.text
        let ordered = NewOrderVC.chosenProducts
        
        let count = ordered.count
        
        for i in 0...(count - 2) {
            if ordered[i].dealerID != ordered[i+1].dealerID {
                self.makeAlert(title: "Error", message: "You should choose products from only one store!")
            }
        }
        
        DatabaseManager.shared.getStoreSettings(storeID: ordered[0].dealerID) { storeSettings in
            switch storeSettings {
            case .failure(_):
                self.makeAlert(title: "Error", message: "Could not check store settings")
                break
            case .success(let store):
                let store: StoreModel = store
                let storePrice = Double(store.minPrice)!
                let orderPrice = Double(total!)!
                guard storePrice <= orderPrice else {
                    self.makeAlert(title: "Sorry", message: "You purchase amount is below the store's minimum price ")
                    return
                }
                
                DatabaseManager.shared.giveOrder(description: comment ?? "No comment",
                                                 total: total!,
                                                 orderModel: ordered) { success in
                    if success {
                        NewOrderVC.chosenProducts.removeAll(keepingCapacity: false)
                        self.totalLabel.text = ""
                        self.commentText.text = ""
                        self.tableView.reloadData()
                        self.makeAlert(title: "Success", message: "Your order sent")
                    } else {
                        self.makeAlert(title: "Error", message: "Could not order. Please try again!")
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewOrderVC.chosenProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier,
                                                 for: indexPath) as! CartTableViewCell
        cell.configure(with: NewOrderVC.chosenProducts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NewOrderVC.chosenProducts.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
}
