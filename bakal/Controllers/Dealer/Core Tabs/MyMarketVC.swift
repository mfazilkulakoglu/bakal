//
//  MyMarketVC.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit

class MyMarketVC: UIViewController {
    
    static let shared = MyMarketVC()
    
    public var categories = [String]()
    
    private var sections = [ProductMap]()
    
    private let headerPhoto: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleToFill
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
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pickThePhoto))
        headerPhoto.addGestureRecognizer(gesture)
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Add Category",
                                                                                          style: .plain,
                                                                                          target: self,
                                                                                          action: #selector(addNewCategoryCell))
        
        addSubviews()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        statementText.delegate = self
        
      
        
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
    
    
    
    func addSubviews() {
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
        let alert = UIAlertController(title: "Add Category",
                                      message: "You can type the category name",
                                      preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].delegate = self
        let action = UIAlertAction(title: "Add", style: .default) { success in
            if alert.textFields![0].text! != "" {
                let title = alert.textFields![0].text!
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
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
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: MyStoreCategoryTVCell.identifier) as! MyStoreCategoryTVCell
            cell.categoryText.text = "Cell"
            cell.delegate = self
            return cell
        } else {
            let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as! ProductTableViewCell
            cell.delegate = self
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
        let vc = NewProductVC()
        self.present(vc, animated: true)
    }
}

