//
//  NewOrderVC.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 20.05.2022.
//
import Foundation
import UIKit
import CoreLocation

//protocol LiveOrderedProductsProtocol: AnyObject {
//    func addProductToCart(_ products: [ChosenProduct])
//}

class NewOrderVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private var id = String()
    private var store = [String : [ProductModel]]()
    static var chosenProducts = [ChosenProduct]()
    let customAlert = AddProductAlert()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getStore(id: self.id)
        }
        initializeHideKeyboard()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.width / 2 - 15,
                                 height: view.width - 30)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapProduct))
        collectionView.addGestureRecognizer(tap)
        collectionView.isUserInteractionEnabled = true
        
        customAlert.unitText.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        collectionView.frame = CGRect(x: 0,
                                      y: tabBarHeight + 10,
                                      width: view.width,
                                      height: view.height - (2 * tabBarHeight + 10))
    }
    
    @objc func didTapProduct(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView.indexPathForItem(at: sender.location(in: self.collectionView)) {
            guard let model = store["\((Array(self.store.keys))[indexPath.section])"]![indexPath.row] as? ProductModel else {
                return
            }
            let storeID = model.storeID
            DatabaseManager.shared.getStoreSettings(storeID: storeID) { store in
                switch store {
                case .failure(_):
                    self.makeAlert(title: "Error", message: "Could not download store settings!")
                    break
                case .success(let storeSettings):
                    let storeSettings: StoreModel = storeSettings
                    DatabaseManager.shared.getCustomerSettings { customer in
                        switch customer {
                        case .failure(_):
                            self.makeAlert(title: "Error", message: "Could not check your settings!")
                            break
                        case .success(let customerSettings):
                            let date = Date.now
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH.mm"
                            let dateString = dateFormatter.string(from: date)
                            let dateDouble = Double(dateString)!
                            let customerSettings: CustomerSettings = customerSettings
                            
                            let customerLocation = CLLocation(latitude: customerSettings.customerLatitude,
                                                              longitude: customerSettings.customerLongitude)
                            let storeLocation = CLLocation(latitude: storeSettings.storeLatitude,
                                                           longitude: storeSettings.storeLongitude)
                            let distanceInMeters = (customerLocation.distance(from: storeLocation)) / 1000.0
                            let maxDistance = Double(storeSettings.maxDistance)!
                            
                            guard distanceInMeters <= maxDistance else {
                                self.makeAlert(title: "Sorry", message: "You are out of the store's delivery range")
                                return
                            }
                            let opening = Double(storeSettings.openingTime)!
                            let closing = Double(storeSettings.closingTime)!
                            
                            guard dateDouble >= opening && dateDouble <= closing else {
                                self.makeAlert(title: "Sorry", message: "The store has not opened yet")
                                return
                            }
                            if model.productStatu == "Available" {
                                
                                self.customAlert.showAlert(with: model,
                                                      id: self.id,
                                                      on: self)
                            } else {
                                self.makeAlert(title: "Sorry!", message: "Out of stock!")
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    init(storeID: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.id = storeID ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getStore(id: String)  {
        DatabaseManager.shared.showProducts(id: id) { downloaded in
            switch downloaded {
            case .failure(_):
                self.makeAlert(title: "Error", message: "Products could not download!")
                break
            case.success(let products):
                self.store = products
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let number = (Array(self.store.keys)).count
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let number = self.store["\((Array(self.store.keys))[section])"]!.count
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier,
                                                      for: indexPath) as! ProductCollectionViewCell
        let model = store["\((Array(self.store.keys))[indexPath.section])"]![indexPath.row]
        cell.configure(with: model)
        self.collectionView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: HeaderCollectionReusableView.identifier,
                                                                     for: indexPath) as! HeaderCollectionReusableView
        let categoryName = (Array(self.store.keys))[indexPath.section]
        header.configure(with: categoryName)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 40)
    }
    
}

extension NewOrderVC: UITextFieldDelegate {
    func updateLabel(textField: UITextField) {
        if textField == customAlert.unitText {
            guard let text = textField.text else {
                return
            }
            if text != nil || text != "" {
                guard (Double(text) ?? 0.0) > 0.0 else {
                    customAlert.addButton.backgroundColor = .systemBackground
                    customAlert.addButton.setTitleColor(.secondarySystemBackground, for: .normal)
                    customAlert.addButton.isEnabled = false
                    return
                }
                guard let model = customAlert.model else {
                    return
                }
                customAlert.totalLabel.text = String(format: "%.2f" ,Double(model.productPrice)! * (Double(text) ?? 0.0))
                customAlert.addButton.backgroundColor = .systemGreen
                customAlert.addButton.setTitleColor(.white, for: .normal)
                customAlert.addButton.isEnabled = true
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLabel(textField: textField)
    }
}

