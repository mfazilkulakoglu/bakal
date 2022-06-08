//
//  ProfileViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit
import FirebaseAuth
import MapKit

class ProfileViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    private let nameText: UITextField = {
       let field = UITextField()
        field.placeholder = "Name, Surname..."
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        field.returnKeyType = .continue
        return field
    }()
    
    private let phoneText: UITextField = {
        let field = UITextField()
        field.placeholder = "Phone..."
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        field.returnKeyType = .continue
        field.keyboardType = .numberPad
        field.textContentType = .telephoneNumber
        return field
    }()
    
    private let addressText: UITextField = {
        let field = UITextField()
        field.placeholder = "Address..."
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        field.returnKeyType = .continue
        field.textContentType = .fullStreetAddress
        return field
    }()
    
    private let addressTitle: UITextField = {
       let field = UITextField()
        field.placeholder = "Address Title..."
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        field.returnKeyType = .continue
        return field
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBackground
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        nameText.frame = CGRect(x: 25,
                                y: tabBarHeight + 10,
                                width: view.width - 50,
                                height: 42)
        phoneText.frame = CGRect(x: 25,
                                 y: nameText.bottom + 10,
                                 width: view.width - 50,
                                 height: 42)
        addressText.frame = CGRect(x: 25,
                                   y: phoneText.bottom + 10,
                                   width: view.width - 50,
                                   height: 42)
        addressTitle.frame = CGRect(x: 25,
                                    y: addressText.bottom + 10,
                                    width: view.width - 50,
                                    height: 42)
        deleteAccountButton.frame = CGRect(x: 25,
                                           y: view.height - (tabBarHeight + 50),
                                           width: view.width - 50,
                                           height: 40)
        saveButton.frame = CGRect(x: 25,
                                  y: deleteAccountButton.top - 50,
                                  width: view.width - 50,
                                  height: 40)
        mapView.frame = CGRect(x: 30,
                               y: addressTitle.bottom + 10,
                               width: view.width - 60,
                               height: saveButton.top - addressTitle.bottom - 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(didTapLogOutButton))
        initializeHideKeyboard()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
        saveButton.addTarget(self,
                             action: #selector(didTapSaveButton),
                             for: .touchUpInside)
        deleteAccountButton.addTarget(self,
                                      action: #selector(didTapDeleteButton),
                                      for: .touchUpInside)
        locationManager.stopUpdatingLocation()
        getCustomerSettings()
    }
    
    private func addSubviews() {
        view.addSubview(nameText)
        view.addSubview(phoneText)
        view.addSubview(addressText)
        view.addSubview(saveButton)
        view.addSubview(deleteAccountButton)
        view.addSubview(mapView)
        view.addSubview(addressTitle)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        if self.nameText.text == "" {
            self.makeAlert(title: "Error", message: "Please check your name!")
        } else if self.phoneText.text == "" {
            self.makeAlert(title: "Error", message: "Please check your phone number!")
        } else if self.addressTitle.text == "" {
            self.makeAlert(title: "Error", message: "Please type your address title!")
        } else if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            self.mapView.removeAnnotations(mapView.annotations)
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = addressTitle.text
            
            
            self.mapView.addAnnotation(annotation)
            
            self.saveButton.backgroundColor = .systemGreen
            self.saveButton.setTitleColor(.white, for: .normal)
            self.saveButton.isEnabled = true
        }
    }
    
    private func getCustomerSettings() {
        DatabaseManager.shared.getCustomerSettings { customerSettings in
            switch customerSettings {
            case .success(let customer):
                self.nameText.text = customer.name
                self.phoneText.text = customer.phone
                self.addressText.text = customer.address
                self.addressTitle.text = customer.addressTitle
                let annotation = MKPointAnnotation()
                let location = CLLocationCoordinate2D(latitude: customer.customerLatitude,
                                                      longitude: customer.customerLongitude)
                annotation.coordinate.latitude = location.latitude
                annotation.coordinate.longitude = location.longitude
                annotation.title = self.nameText.text
                
                
                self.mapView.addAnnotation(annotation)
                self.saveButton.backgroundColor = .systemGreen
                self.saveButton.setTitleColor(.white, for: .normal)
                self.saveButton.isEnabled = true
                
            case .failure(_): break
            }
        }
    }
    
    @objc func didTapSaveButton() {
        
        nameText.resignFirstResponder()
        addressText.resignFirstResponder()
        addressTitle.resignFirstResponder()
        phoneText.resignFirstResponder()
        
        if mapView.annotations.isEmpty {
            self.makeAlert(title: "Error", message: "Please choose your location!")
        } else {
           // Database: Save your personal info !!!
            DatabaseManager.shared.getAccountID { [self] email, id in
                guard email != "" && id != "" else {
                    self.makeAlert(title: "Error", message: "Could not get account info!")
                    return
                }
                let customer = CustomerSettings(name: nameText.text!,
                                                email: email,
                                                id: id,
                                                phone: phoneText.text!,
                                                address: addressText.text!,
                                                addressTitle: addressTitle.text!,
                                                customerLatitude: self.mapView.annotations[0].coordinate.latitude,
                                                customerLongitude: self.mapView.annotations[0].coordinate.longitude)
                DatabaseManager.shared.saveCustomerSettings(customerSettings: customer) { success in
                    if success {
                        self.makeAlert(title: "Success", message: "Your account has been updated")
                    } else {
                        self.makeAlert(title: "Error", message: "Could not updated!")
                    }
                }
            }
        }
    }
    
    @objc private func didTapDeleteButton() {
        let alert = UIAlertController(title: "Are you sure?", message: "The account will delete!", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            DatabaseManager.shared.deleteCustomerAccount { result in
                switch result {
                case .failure(let error):
                    print("\(error)")
                case .success(_):
                    let loginVC: UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: "SıgnInVC") as?    UIViewController
                    loginVC?.modalPresentationStyle = .fullScreen
                    self.present(loginVC!, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc private func didTapLogOutButton() {
        AuthManager.shared.logOut { success in
            if success {
                let loginVC: UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: "SıgnInVC") as?    UIViewController
                loginVC?.modalPresentationStyle = .fullScreen
                self.present(loginVC!, animated: true, completion: nil)
            } else {
                self.makeAlert(title: "Error", message: "Could not log out")
            }
        }
        
    }
    
    
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameText {
            phoneText.becomeFirstResponder()
        } else if textField == phoneText {
            addressText.becomeFirstResponder()
        } else if textField == addressText {
            addressTitle.becomeFirstResponder()
        }
        return true
    }
}
