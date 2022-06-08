//
//  OrderViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit

class OrdersVC: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var orderList = [OrderInfos]()
    private let customAlert = OrderDetailChange()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        tableView.frame = CGRect(x: 0,
                                 y: tabBarHeight + 10,
                                 width: view.width,
                                 height: view.height - (2 * tabBarHeight + 20))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        customAlert.tableView.delegate = self
        customAlert.tableView.dataSource = self
        
        DispatchQueue.main.async {
            self.getOrderList()
            self.tableView.reloadData()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.getOrderList()
            self.tableView.reloadData()
        }
    }
    
    private func getOrderList() {
        DatabaseManager.shared.getOrderInfosToDealer { orderList in
            switch orderList {
            case .failure(_):
                self.makeAlert(title: "Error", message: "No order")
                break
            case .success(let list):
                self.orderList = list
                self.tableView.reloadData()
            }
        }
        
    }
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.orderList[indexPath.row].comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DatabaseManager.shared.getOrderToCustomer(info: orderList[indexPath.row]) { result in
            switch result {
            case .failure(_):
                break
            case .success(let products):
                let givenOrder = GivenOrder(products: products,
                                            orderInfo: self.orderList[indexPath.row])
                self.customAlert.showAlert(with: givenOrder, on: self)
            }
        }
        
        
    }
}
