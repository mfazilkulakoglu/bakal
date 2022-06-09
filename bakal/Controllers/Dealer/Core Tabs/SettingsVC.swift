//
//  SettingsVC.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit
import MapKit

struct Coordinates {
    var latitude = String()
    var longitude = String()
}

class SettingsVC: UIViewController {
    
    private let storeTypeArray = ["General Store", "Greengrocer", "Butcher Shop", "Restaurant", "Patisserie", "Coffee Shop", "Souvenir Shop", "Flower Store", "Other"]
    private let timeHourArray = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    private let timeMinArray = ["00", "15", "30", "45"]
    
    var locationManager = CLLocationManager()
    
    private var storeTypePicker = UIPickerView()
    private var startTimePicker = UIPickerView()
    private var finishTimePicker = UIPickerView()
    
    private let storeType: UITextField = {
        let field = UITextField()
        field.placeholder = "Store Type..."
        field.textAlignment = .center
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.backgroundColor = .systemBackground
        return field
    }()
    
    private let storeName: UITextField = {
        let field = UITextField()
        field.placeholder = "Store Name..."
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
    
    private let priceText: UITextField = {
        let field = UITextField()
        field.placeholder = "Min. Price..."
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
        return field
    }()
    
    private let distanceText: UITextField = {
        let field = UITextField()
        field.placeholder = "Max. Distance..."
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
        return field
    }()
    
    private let openingTimeText: UITextField = {
        let field = UITextField()
        field.placeholder = "Opening Time..."
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
        field.keyboardType = .default
        return field
    }()
    
    private let closingTimeText: UITextField = {
        let field = UITextField()
        field.placeholder = "Closing Time..."
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
        field.keyboardType = .default
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
        storeType.frame = CGRect(x: 25,
                                 y: tabBarHeight + 10,
                                 width: view.width - 50,
                                 height: 42)
        storeName.frame = CGRect(x: 25,
                                 y: storeType.bottom + 10,
                                 width: view.width - 50,
                                 height: 42)
        addressText.frame = CGRect(x: 25,
                                  y: storeName.bottom + 10,
                                  width: view.width - 50,
                                  height: 42)
        phoneText.frame = CGRect(x: 25,
                                 y: addressText.bottom + 10,
                                 width: view.width - 50,
                                 height: 42)
        priceText.frame = CGRect(x: 25,
                                 y: phoneText.bottom + 10,
                                 width: view.width/2 - 30,
                                 height: 42)
        distanceText.frame = CGRect(x: priceText.right + 10,
                                    y: phoneText.bottom + 10,
                                    width: priceText.width,
                                    height: 42)
        openingTimeText.frame = CGRect(x: 25,
                                       y: priceText.bottom + 10,
                                       width: priceText.width,
                                       height: 42)
        closingTimeText.frame = CGRect(x: openingTimeText.right + 10,
                                       y: distanceText.bottom + 10,
                                       width: priceText.width,
                                       height: 42)
        deleteAccountButton.frame = CGRect(x: 25,
                                           y: view.height - (50),
                                           width: view.width - 50,
                                           height: 40)
        saveButton.frame = CGRect(x: 25,
                                  y: deleteAccountButton.top - 50,
                                  width: view.width - 50,
                                  height: 40)
        mapView.frame = CGRect(x: 25,
                               y: openingTimeText.bottom + 10,
                               width: view.width - 50,
                               height: saveButton.top - openingTimeText.bottom - 20)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeTypePicker.delegate = self
        storeTypePicker.dataSource = self
        startTimePicker.delegate = self
        startTimePicker.dataSource = self
        finishTimePicker.delegate = self
        finishTimePicker.dataSource = self
        storeType.inputView = storeTypePicker
        openingTimeText.inputView = startTimePicker
        closingTimeText.inputView = finishTimePicker
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        getSettingsInfo()
        
        let recognizer = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
        addSubviews()
        initializeHideKeyboard()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(didTapLogOutButton))
        
        saveButton.addTarget(self,
                             action: #selector(didTapSaveButton),
                             for: .touchUpInside)
        deleteAccountButton.addTarget(self,
                                      action: #selector(didTapDeleteAccountButton),
                                      for: .touchUpInside)
        locationManager.stopUpdatingLocation()
    }
    
    func addSubviews() {
        view.addSubview(storeName)
        view.addSubview(storeType)
        view.addSubview(addressText)
        view.addSubview(phoneText)
        view.addSubview(priceText)
        view.addSubview(distanceText)
        view.addSubview(openingTimeText)
        view.addSubview(closingTimeText)
        view.addSubview(saveButton)
        view.addSubview(deleteAccountButton)
        view.addSubview(mapView)
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        if self.storeType.text == "" {
            self.makeAlert(title: "Error", message: "Please check your Store Type!")
        } else if self.storeName.text == "" {
            self.makeAlert(title: "Error", message: "Please check your Store Name!")
        } else if self.phoneText.text == "" {
            self.makeAlert(title: "Error", message: "Please check your Phone Number!")
        } else if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            self.mapView.removeAnnotations(mapView.annotations)
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = storeName.text
            annotation.subtitle = storeType.text
            
            self.mapView.addAnnotation(annotation)
            
            self.saveButton.backgroundColor = .systemGreen
            self.saveButton.setTitleColor(.white, for: .normal)
            self.saveButton.isEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func didTapDeleteAccountButton() {
        let alert = UIAlertController(title: "Are you sure?", message: "The account will delete!", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            DatabaseManager.shared.deleteStoreAccount { result in
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
    
    @objc func didTapSaveButton() {
        
        storeType.resignFirstResponder()
        storeName.resignFirstResponder()
        addressText.resignFirstResponder()
        phoneText.resignFirstResponder()
        priceText.resignFirstResponder()
        distanceText.resignFirstResponder()
        openingTimeText.resignFirstResponder()
        closingTimeText.resignFirstResponder()
        
        if priceText.text == "" {
            self.makeAlert(title: "Error", message: "Please write your minimum price you can get order!")
        } else if distanceText.text == "" {
            self.makeAlert(title: "Error", message: "Please write your maximum distance you can service!")
        } else if openingTimeText.text == "" {
            self.makeAlert(title: "Error", message: "Please choose your opening time!")
        } else if closingTimeText.text == "" {
            self.makeAlert(title: "Error", message: "Please choose your closing time!")
        } else if mapView.annotations.isEmpty {
            self.makeAlert(title: "Error", message: "Please choose your location!")
        } else {
            DatabaseManager.shared.getAccountID { [self] email, id in
                guard email != "" && id != "" else {
                    self.makeAlert(title: "Error", message: "Could not reach your account info")
                    return
                }
                StorageManager.shared.downloadStorePhoto { [self] storePhoto in
                    switch storePhoto {
                    case .failure(_):
                        StorageManager.shared.uplooadPhoto(image: UIImage(systemName: "plus.circle.fill")!, name: "StorePhoto") { [self] uploaded in
                            switch uploaded {
                            case .failure(let error):
                                self.makeAlert(title: "Error", message: error.localizedDescription)
                            case .success(let resultURL):
                                let storeObject = StoreModel(email: email,
                                                             id: id,
                                                             storeType: storeType.text!,
                                                             storeName: storeName.text!,
                                                             adress: addressText.text!,
                                                             phone: phoneText.text!,
                                                             minPrice: priceText.text!,
                                                             maxDistance: distanceText.text!,
                                                             openingTime: openingTimeText.text!,
                                                             closingTime: closingTimeText.text!,
                                                             storeImageUrl: resultURL,
                                                             storeLatitude: mapView.annotations[0].coordinate.latitude,
                                                             storeLongitude: mapView.annotations[0].coordinate.longitude)
                                DatabaseManager.shared.saveStorySettings(storePost: storeObject) { result in
                                    switch result {
                                    case .failure(_):
                                        self.makeAlert(title: "Error", message: "Could not save!")
                                    case .success(_):
                                        self.makeAlert(title: "Success", message: "Your settings saved")
                                    }
                                }
                            }
                        }
                    case .success(let resultURL):
                        let storeObject = StoreModel(email: email,
                                                     id: id,
                                                     storeType: storeType.text!,
                                                     storeName: storeName.text!,
                                                     adress: addressText.text!,
                                                     phone: phoneText.text!,
                                                     minPrice: priceText.text!,
                                                     maxDistance: distanceText.text!,
                                                     openingTime: openingTimeText.text!,
                                                     closingTime: closingTimeText.text!,
                                                     storeImageUrl: resultURL,
                                                     storeLatitude: mapView.annotations[0].coordinate.latitude,
                                                     storeLongitude: mapView.annotations[0].coordinate.longitude)
                        
                        DatabaseManager.shared.saveStorySettings(storePost: storeObject) { result in
                            switch result {
                            case .failure(_):
                                self.makeAlert(title: "Error", message: "Could not save!")
                            case .success(_):
                                self.makeAlert(title: "Success", message: "Your settings saved")
                            }
                        }
                    }
                }
            }
        }
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
    
    private func getSettingsInfo() {
        DatabaseManager.shared.getSettings { storeSettings in
            switch storeSettings {
            case .success(let storeSet):
                self.storeType.text = storeSet.storeType
                self.storeName.text = storeSet.storeName
                self.addressText.text = storeSet.adress
                self.phoneText.text = storeSet.phone
                self.priceText.text = storeSet.minPrice
                self.distanceText.text = storeSet.maxDistance
                self.openingTimeText.text = storeSet.openingTime
                self.closingTimeText.text = storeSet.closingTime
                
                let annotation = MKPointAnnotation()
                let location = CLLocationCoordinate2D(latitude: storeSet.storeLatitude, longitude: storeSet.storeLongitude)
                annotation.coordinate.latitude = location.latitude
                annotation.coordinate.longitude = location.longitude
                annotation.title = self.storeName.text
                annotation.subtitle = self.storeType.text
                
                self.mapView.addAnnotation(annotation)
                self.saveButton.backgroundColor = .systemGreen
                self.saveButton.setTitleColor(.white, for: .normal)
                self.saveButton.isEnabled = true
                
            case .failure(_): break
            }
        }
    }
}

extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == storeTypePicker {
            return storeTypeArray.count
        } else {
            if component == 0 {
                return timeHourArray.count
            } else {
                return timeMinArray.count
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == storeTypePicker {
            return 1
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == storeTypePicker {
            return storeTypeArray[row]
        } else {
            if component == 0 {
                return timeHourArray[row]
            } else {
                return timeMinArray[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == storeTypePicker {
            storeType.text = storeTypeArray[row]
        } else if pickerView == startTimePicker {
            openingTimeText.text = "\(timeHourArray[pickerView.selectedRow(inComponent: 0)]).\(timeMinArray[pickerView.selectedRow(inComponent: 1)])"
        } else {
            closingTimeText.text = "\(timeHourArray[pickerView.selectedRow(inComponent: 0)]).\(timeMinArray[pickerView.selectedRow(inComponent: 1)])"
        }
    }
}

extension SettingsVC: MKMapViewDelegate, CLLocationManagerDelegate {
    
}

extension SettingsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == storeType {
            storeName.becomeFirstResponder()
        } else if textField == storeName {
            addressText.becomeFirstResponder()
        } else if textField == addressText {
            phoneText.becomeFirstResponder()
        } else if textField == phoneText {
            priceText.becomeFirstResponder()
        } else if textField == priceText {
            distanceText.becomeFirstResponder()
        } else if textField == distanceText {
            openingTimeText.becomeFirstResponder()
        } else if textField == openingTimeText {
            closingTimeText.becomeFirstResponder()
        }
        return true
    }
}
