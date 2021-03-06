//
//  ViewController.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 15.04.2022.
//

import UIKit

class NewProductVC: UIViewController {
    
    static let initializer = "NewProductVC"
    
    var product: ProductModel
    
    private let productPhoto: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let productCategoryText: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.placeholder = "Product Category..."
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let productNameText: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.placeholder = "Product Name..."
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let productCommentText: UITextField = {
        let field = UITextField()
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.placeholder = "Product Comment..."
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let unitPicker = UIPickerView()
    private let unitArray = ["t", "kg", "g", "l", "ml", "pcs"]
    
    private let productUnitText: UITextField = {
        let field = UITextField()
        field.placeholder = "Unit..."
        field.textAlignment = .center
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        field.keyboardType = .decimalPad
        return field
    }()
    
    private let productUnitTypeText: UITextField = {
        let field = UITextField()
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.placeholder = "Please type peaces detail"
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let productPriceText: UITextField = {
        let field = UITextField()
        field.placeholder = "Price..."
        field.textAlignment = .center
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        field.keyboardType = .decimalPad
        return field
    }()
    
    var stockStatu = true
    
    private let stockButton: UIButton = {
        let button = UIButton()
        button.setTitle("Available", for: .normal)
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        //        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        productCategoryText.delegate = self
        productNameText.delegate = self
        productCommentText.delegate = self
        unitPicker.delegate = self
        unitPicker.dataSource = self
        productUnitTypeText.inputView = unitPicker
        addSubviews()
        initializeHideKeyboard()
        stockButton.addTarget(self,
                              action: #selector(didTapStockButton),
                              for: .touchUpInside)
        saveButton.addTarget(self,
                             action: #selector(tappedSaveButton),
                             for: .touchUpInside)
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        productPhoto.addGestureRecognizer(gestureRec)
        loadProduct()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let firstVC = presentingViewController as? MyMarketVC {
            DispatchQueue.main.async {
                firstVC.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        productPhoto.frame = CGRect(x: view.width/3,
                                    y: tabBarHeight + 20,
                                    width: view.width/3,
                                    height: view.width/3)
        productCategoryText.frame = CGRect(x: 25,
                                           y: productPhoto.bottom + 20,
                                           width: view.width - 50,
                                           height: 42)
        productNameText.frame = CGRect(x: 25,
                                       y: productCategoryText.bottom + 10,
                                       width: view.width - 50,
                                       height: 42)
        productCommentText.frame = CGRect(x: 25,
                                          y: productNameText.bottom + 10,
                                          width: view.width - 50,
                                          height: 42)
        productUnitText.frame = CGRect(x: 25,
                                       y: productCommentText.bottom + 10,
                                       width: view.width/2 - 30,
                                       height: 42)
        productUnitTypeText.frame = CGRect(x: productUnitText.right + 10,
                                           y: productUnitText.top,
                                           width: view.width/2 - 30,
                                           height: 42)
        productPriceText.frame = CGRect(x: 25,
                                        y: productUnitText.bottom + 10,
                                        width: view.width/2 - 30,
                                        height: 42)
        stockButton.frame = CGRect(x: productPriceText.right + 10,
                                   y: productPriceText.top,
                                   width: view.width/2 - 30,
                                   height: 42)
        saveButton.frame = CGRect(x: view.width/4 + 15,
                                  y: productPriceText.bottom + 20,
                                  width: view.width/2 - 30,
                                  height: 42)
    }
    
    func addSubviews() {
        view.addSubview(productPhoto)
        view.addSubview(productCategoryText)
        view.addSubview(productNameText)
        view.addSubview(productCommentText)
        view.addSubview(productUnitText)
        view.addSubview(productUnitTypeText)
        view.addSubview(productPriceText)
        view.addSubview(stockButton)
        view.addSubview(saveButton)
        
    }
    
    @objc func tappedBackButton() {
        self.dismiss(animated: true)
    }
    
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func didTapStockButton() {
        if stockStatu == true {
            self.stockButton.setTitle("Not Available", for: .normal)
            self.stockButton.backgroundColor = .systemRed
            stockStatu = false
        } else {
            stockStatu = true
            self.stockButton.setTitle("Available", for: .normal)
            self.stockButton.backgroundColor = .systemGreen
        }
    }
    
    @objc func tappedSaveButton() {
        
        productCategoryText.resignFirstResponder()
        productNameText.resignFirstResponder()
        productCommentText.resignFirstResponder()
        productUnitText.resignFirstResponder()
        productPriceText.resignFirstResponder()
        
        guard productCategoryText.text != nil && productCategoryText.text != "" else {
            makeAlert(title: "Error", message: "Type your product's category name!")
            return
        }
        guard productNameText.text != nil && productNameText.text != "" else {
            makeAlert(title: "Error", message: "Type your product name!")
            return
        }
        guard productCommentText.text != nil && productCommentText.text != "" else {
            makeAlert(title: "Error", message: "Type a comment about your product!")
            return
        }
        guard productUnitText.text != nil && productUnitText.text != "" else {
            makeAlert(title: "Error", message: "Choose your product's type!")
            return
        }
        guard productPriceText.text != nil && productPriceText.text != "" else {
            makeAlert(title: "Error", message: "Type your product's price!")
            return
        }
        
        StorageManager.shared.uplooadPhoto(image: self.productPhoto.image!, name: "\(self.productCategoryText.text!)\(self.productNameText.text!)") { uploaded in
            switch uploaded {
            case .failure(_):
                self.makeAlert(title: "Error", message: "Could not save the image!")
            case . success(let imageLink):
                DispatchQueue.main.async {
                    var id = self.product.id
                    if id == "" {
                        id = UUID().uuidString
                    }
                    self.product = ProductModel(id,
                                                self.productCategoryText.text!,
                                                self.productNameText.text!,
                                                self.productCommentText.text!,
                                                self.productUnitText.text!,
                                                self.productUnitTypeText.text!,
                                                imageLink,
                                                self.productPriceText.text!,
                                                self.stockButton.title(for: .normal)!,
                                                Date.now,
                                                "",
                                                "")
                    DatabaseManager.shared.saveProducts(categoryName: self.productCategoryText.text!, product: self.product) { success in
                        if success {
                            self.dismiss(animated: true)
                            
                        } else {
                            self.makeAlert(title: "Error", message: "Could not save product")
                        }
                    }
                }
            }
        }
    }
    
    init(product: ProductModel? = nil) {
        let emptyProduct = ProductModel("", "", "", "", "", "", "", "", "", Date.now, "", "")
        self.product = product ?? emptyProduct
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadProduct() {
        if self.product.productPhoto.contains("https") {
            self.productPhoto.sd_setImage(with: URL(string: self.product.productPhoto))
        }
        self.productCategoryText.text = self.product.productCategory
        self.productNameText.text = self.product.productName
        self.productCommentText.text = self.product.productComment
        self.productUnitText.text = self.product.productUnit
        self.productUnitTypeText.text = self.product.productUnitType
        self.productPriceText.text = self.product.productPrice
        if self.product.productStatu == "Available" {
            self.stockStatu = true
            self.stockButton.setTitle("Available", for: .normal)
            self.stockButton.backgroundColor = .systemGreen
        } else {
            self.stockButton.setTitle("Not Available", for: .normal)
            self.stockButton.backgroundColor = .systemRed
            stockStatu = false
        }
    }
    
}



extension NewProductVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == productCategoryText {
            productNameText.becomeFirstResponder()
        } else if textField == productNameText {
            productCommentText.becomeFirstResponder()
        } else if textField == productCommentText {
            productUnitText.becomeFirstResponder()
        } else if textField == productUnitText {
            productPriceText.becomeFirstResponder()
        } else if textField == productPriceText {
            tappedSaveButton()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if textField == self.productNameText {
            return updatedText.count <= 16
        } else if textField == self.productCategoryText {
            return updatedText.count <= 30
        } else if textField == self.productCommentText {
            return updatedText.count <= 28
        }
        return true
    }
}

extension NewProductVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        unitArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        productUnitTypeText.text = unitArray[pickerView.selectedRow(inComponent: 0)]
    }
}

extension NewProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        productPhoto.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}

