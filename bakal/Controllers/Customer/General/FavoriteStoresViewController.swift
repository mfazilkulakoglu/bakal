//
//  FavoriteStoresViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 20.05.2022.
//

import UIKit
import Foundation

class FavoriteStoresViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
       return tableView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 49.0
        tableView.frame = CGRect(x: 0,
                                 y: tabBarHeight + 10,
                                 width: view.width,
                                 height: view.height - (2 * tabBarHeight + 10))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

    }
  
}

extension FavoriteStoresViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Sample"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
