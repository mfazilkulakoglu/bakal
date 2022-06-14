//
//  OrderDetail.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 5.06.2022.
//

import Foundation
import UIKit
import MapKit

public class ShowMap: UIView, MKMapViewDelegate, CLLocationManagerDelegate {
    
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
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        return map
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
    
    public var model: GivenOrder?
    private var id: String?
    private var myTargetView: UIView?
    private var customer: CustomerSettings?
    private var locationManager = CLLocationManager()
    private var showCustomerDetail = CustomerDetail()
    private var viewController: UIViewController?
    
    func showAlert(with model: GivenOrder, on viewController: UIViewController) {
        
        guard let targetView = viewController.view else {
            return
        }
        self.model = model
        self.myTargetView = targetView
        self.viewController = viewController
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        detailView.frame = CGRect(x: 2 * targetView.width,
                                  y: 100,
                                  width: targetView.width - 80,
                                  height: targetView.height - 200)
        okButton.frame = CGRect(x: 5,
                                y: detailView.height - 45,
                                width: detailView.width - 10,
                                height: 40)
        mapView.frame = CGRect(x: 5,
                               y: 5,
                               width: detailView.width - 10,
                               height: okButton.top - 10)
        
        
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(detailView)
        detailView.addSubview(okButton)
        detailView.addSubview(mapView)
        
        DispatchQueue.main.async {
            DatabaseManager.shared.getCustomer(id: self.model!.orderInfo.customerID) { customerResult in
                switch customerResult {
                case .failure(_):
                    break
                case .success(let customerSettings):
                    self.customer = customerSettings
                    
                    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                        let customerLatitude = Double(self.customer!.customerLatitude)
                        let customerLongitude = Double(self.customer!.customerLongitude)
                        let location = CLLocationCoordinate2D(latitude: customerLatitude, longitude: customerLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.mapView.setRegion(region, animated: true)
                    }
                    
                    let annotation = CustomerAnnotation()
                    annotation.coordinate.latitude = Double(self.customer!.customerLatitude)
                    annotation.coordinate.longitude = Double(self.customer!.customerLongitude)
                    annotation.title = self.customer!.name
                    annotation.subtitle = self.customer!.addressTitle
                    annotation.customer = self.customer
                    self.mapView.addAnnotation(annotation)
                      
                }
            }
            
        }
        
        
        
        
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
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
    
    
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let selectedAnnotation = mapView.selectedAnnotations[0] as? CustomerAnnotation {
            let customerProfile = selectedAnnotation.customer
            let customerLatitude = Double(customerProfile!.customerLatitude)
            let customerLongitude = Double(customerProfile!.customerLongitude)
            let requestLocation = CLLocation(latitude: customerLatitude, longitude: customerLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        item.name = mapView.annotations[0].title!
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
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
            self.detailView.frame = CGRect(x: 2 * targetView.width,
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
                        
                        showCustomerDetail.showAlert(with: self.model!,
                                                     customer: self.customer!,
                                                     on: self.viewController!)
                        
                    }
                }
            }
        }
    }
    
}
