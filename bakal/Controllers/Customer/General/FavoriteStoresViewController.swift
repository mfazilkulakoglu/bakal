//
//  FavoriteStoresViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 20.05.2022.
//

import UIKit

class FavoriteStoresViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
       return tableView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 49.0
        tableView.frame = CGRect(x: 20,
                                 y: tabBarHeight + 10,
                                 width: view.width - 40,
                                 height: view.height - (2 * tabBarHeight + 20))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NewOrderVC()
        present(vc, animated: true)
    }
}
