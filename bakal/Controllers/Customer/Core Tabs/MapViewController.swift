//
//  SearchViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let mapView: MKMapView = {
       let mapView = MKMapView()
        return mapView
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        mapView.frame = CGRect(x: 15,
                               y: tabBarHeight + 10,
                               width: view.width - 30,
                               height: view.height - (2 * tabBarHeight + 10))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"),
                                                                                          style: .plain,
                                                                                          target: self,
                                                                                          action: #selector(didTapFavorites))
    }
    
    @objc func didTapFavorites() {
        print("Tapped Favorites")
        DatabaseManager.shared.getStoresIDs { downloaded in
            switch downloaded {
            case .failure(_):
                print("Olmadı")
            case .success(let yes):
                print(yes)
            }
        }
    }



}
