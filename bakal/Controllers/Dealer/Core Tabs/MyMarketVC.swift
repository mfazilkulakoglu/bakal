//
//  MyMarketVC.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit

class MyMarketVC: UIViewController {
    
    static let shared = MyMarketVC()
    
    private var myMarket: Dictionary = [String : [ProductModel]]()
    
    private let headerPhoto: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let statementText: UITextField = {
        let field = UITextField()
        field.placeholder = "You can tell about your products"
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyStoreCategoryTVCell.self, forCellReuseIdentifier: MyStoreCategoryTVCell.identifier)
        tableView.register(ProductTableViewCell.nib(), forCellReuseIdentifier: ProductTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pickThePhoto))
        headerPhoto.addGestureRecognizer(gesture)
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                                                          style: .plain,
                                                                                          target: self,
                                                                                          action: #selector(addNewCategoryCell))
        
        addSubviews()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        statementText.delegate = self
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        headerPhoto.frame = CGRect(x: 15,
                                   y: tabBarHeight,
                                   width: view.width - 30,
                                   height: view.height / 4.0)
        statementText.frame = CGRect(x: 20,
                                     y: headerPhoto.bottom + 10,
                                     width: view.width - 40,
                                     height: 52)
        categoryTableView.frame = CGRect(x: 25,
                                         y: statementText.bottom + 10,
                                         width: view.width - 50,
                                         height: (view.height - tabBarHeight - 10) - (headerPhoto.bottom + 10))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    
    
    private func reloadData() {
            DatabaseManager.shared.getProducts { result in
                self.myMarket.removeAll(keepingCapacity: false)
                switch result {
                case .failure(let error):
                    self.makeAlert(title: "Error", message: error.localizedDescription )
                case .success(let dictionary):
                    if let dictionary = dictionary {
                        self.myMarket = dictionary
                    }
                }
            }
        self.categoryTableView.reloadData()
    }
    
    private func addSubviews() {
        view.addSubview(headerPhoto)
        view.addSubview(statementText)
        view.addSubview(categoryTableView)
    }
    
    @objc func pickThePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    // MARK: ----- Add New Category -----
    
    @objc func addNewCategoryCell() {
        let vc = NewProductVC()
        self.present(vc, animated: true)
        self.categoryTableView.reloadData()
        print(self.myMarket)
    }
    
}
// MARK: ----- EXTENSIONS -----

extension MyMarketVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        headerPhoto.addSubview(UIImageView(image: info[.originalImage] as? UIImage))
        self.dismiss(animated: true)
    }
}

extension MyMarketVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (Array(self.myMarket.keys)).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: MyStoreCategoryTVCell.identifier, for: indexPath) as! MyStoreCategoryTVCell
            cell.categoryText.text = (Array(self.myMarket.keys))[indexPath.section]
            cell.delegate = self
            return cell
        } else {
            let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
            cell.delegate = self
            var collectionArray = [ProductModel]()
            for productX in self.myMarket["\((Array(self.myMarket.keys))[indexPath.section])"]! {
                collectionArray.append(productX)
            }
            cell.configure(with: collectionArray)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // delete on firebase
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 260.0
        }
        return UITableView.automaticDimension
    }
    
}

extension MyMarketVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if textField == self.statementText {
            return updatedText.count <= 120
        } else {
            return updatedText.count <= 22
        }
        
    }
}

extension MyMarketVC: MyStoreCategoryTVCellDelegate {
    func tappedAddCategoryButton() {
        let vc = NewProductVC()
        self.present(vc, animated: true)
    }
}

extension MyMarketVC: ProductTableViewCellDelegate {
    func tappedProductionCollection() {
        //        let vc = NewProductVC()
        //        self.present(vc, animated: true)
    }
}
