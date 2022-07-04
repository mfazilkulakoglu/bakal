//
//  SearchViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var stores = [StoreModel]()
    let locationManager = CLLocationManager()
    
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
        initializeHideKeyboard()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        view.addSubview(mapView)

        DispatchQueue.main.async {
            self.getStoresInfo()
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }

    private func getStoresInfo() {
        
            DatabaseManager.shared.getStores { downloaded in
                switch downloaded {
                case .failure(_):
                    self.makeAlert(title: "Error", message: "Sorry. There is no store we can show you :( ")
                case .success(let stores):
                    self.stores = stores
                    for store in stores {
                        let annotation = StoreAnnotation()
                        let location = CLLocationCoordinate2D(latitude: store.storeLatitude, longitude: store.storeLongitude)
                        annotation.coordinate.latitude = location.latitude
                        annotation.coordinate.longitude = location.longitude
                        annotation.title = store.storeName
                        annotation.subtitle = store.storeType
                        annotation.storeModel = store
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            let rightButton = UIButton(type: .infoDark)
            rightButton.tag = annotation.hash
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            
            return pinView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
            if let selectedAnn = mapView.selectedAnnotations[0] as? StoreAnnotation {
                let id = selectedAnn.storeModel!.id
                let vc = NewOrderVC(storeID: id)          
                vc.modalPresentationStyle = .fullScreen
                self.show(vc, sender: nil)
            }
        
    }
    
}
