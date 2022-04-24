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
    
    private let adressText: UITextField = {
        let field = UITextField()
        field.placeholder = "Adress..."
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
        adressText.frame = CGRect(x: 25,
                                  y: storeName.bottom + 10,
                                  width: view.width - 50,
                                  height: 42)
        phoneText.frame = CGRect(x: 25,
                                 y: adressText.bottom + 10,
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
        saveButton.frame = CGRect(x: 25,
                                  y: (view.height - 50 - tabBarHeight),
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
    }
    
    func addSubviews() {
        view.addSubview(storeName)
        view.addSubview(storeType)
        view.addSubview(adressText)
        view.addSubview(phoneText)
        view.addSubview(priceText)
        view.addSubview(distanceText)
        view.addSubview(openingTimeText)
        view.addSubview(closingTimeText)
        view.addSubview(saveButton)
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
    
    @objc func didTapSaveButton() {
        
        storeType.resignFirstResponder()
        storeName.resignFirstResponder()
        adressText.resignFirstResponder()
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
                let storeObject = StoreModel(email: email,
                                             id: id,
                                             storeType: storeType.text!,
                                             storeName: storeName.text!,
                                             adress: adressText.text!,
                                             phone: phoneText.text!,
                                             minPrice: priceText.text!,
                                             maxDistance: distanceText.text!,
                                             openingTime: openingTimeText.text!,
                                             closingTime: closingTimeText.text!,
                                             storeLatitude: mapView.annotations[0].coordinate.latitude,
                                             storeLongitude: mapView.annotations[0].coordinate.longitude)
                
                DatabaseManager.shared.saveStorySettings(storePost: storeObject) { success in
                    if success {
                        self.makeAlert(title: "Success", message: "Your account has been updated")
                    } else {
                        self.makeAlert(title: "Error", message: "Could not updated!")
                    }
                }
            }
            
        }
        
    }
    
    @objc private func didTapLogOutButton() {
        AuthManager.shared.logOut { success in
            if success {
                performSegue(withIdentifier: "unwindToSignInFromDealer", sender: self)
            } else {
                self.makeAlert(title: "Error", message: "Could not log out")
            }
        }
    }
    
    private func getSettingsInfo() {
        
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
            adressText.becomeFirstResponder()
        } else if textField == adressText {
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
