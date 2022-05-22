//
//  MyMarketVC.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 11.04.2022.
//

import UIKit
import SDWebImage

class MyMarketVC: UIViewController {
    
    
    
    static let shared = MyMarketVC()
    
    private var myMarket: Dictionary = [String : [ProductModel]]()
    
    private var headerPhoto: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        return image
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
        DispatchQueue.main.async {
            self.reloadData()
        }
        loadPhoto()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        headerPhoto.frame = CGRect(x: 15,
                                   y: tabBarHeight,
                                   width: view.width - 30,
                                   height: view.height / 4.0)
        categoryTableView.frame = CGRect(x: 0,
                                         y: headerPhoto.bottom + 10,
                                         width: view.width,
                                         height: (view.height - (tabBarHeight) - 10) - (headerPhoto.height))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    public func reloadData() {
            DatabaseManager.shared.getProducts { result in
                self.myMarket.removeAll(keepingCapacity: false)
                switch result {
                case .failure(_):
                    print("Problemmmmm!!!!!!!!!!!!!")
                    break
                case .success(let dictionary):
                    if let dictionary = dictionary {
                        self.myMarket = dictionary
                    }
                }
            self.categoryTableView.reloadData()
        }
    }
    
    private func loadPhoto() {
        DatabaseManager.shared.getStorePhoto { storePhotoURL in
            switch storePhotoURL {
            case .failure(_):
                break
            case .success(let photoUrl):
                self.headerPhoto.sd_setImage(with: URL(string: photoUrl))
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(headerPhoto)
        view.addSubview(categoryTableView)
    }
    
    @objc func pickThePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    // MARK: ----- Add New Product -----
    
    @objc func addNewCategoryCell() {
        let vc = NewProductVC()
        self.present(vc, animated: true)
    }
    
}
// MARK: ----- EXTENSIONS -----

extension MyMarketVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.headerPhoto.image = info[.originalImage] as? UIImage
        StorageManager.shared.uplooadPhoto(image: self.headerPhoto.image!, name: "StorePhoto", completion: { uploaded in
            switch uploaded {
            case .failure(_):
                break
            case .success(let imageLink):
                Task {
                do {
                    try await DatabaseManager.shared.saveStoreImage(imageURL: imageLink)
                    self.dismiss(animated: true)
                } catch {
                    self.makeAlert(title: "Error", message: "Could not save image!")
                }
                }
            }
        })
    }
}

extension MyMarketVC: UITableViewDelegate, UITableViewDataSource, ProductTableViewCellDelegate, ProductTableViewCellDeleteDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (Array(self.myMarket.keys)).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 260.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let colorArray : [UIColor] = [UIColor.systemGreen, UIColor.systemYellow, UIColor.systemRed, UIColor.link, UIColor.systemPink, UIColor.purple]
            let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: MyStoreCategoryTVCell.identifier, for: indexPath) as! MyStoreCategoryTVCell
            cell.categoryText.text = (Array(self.myMarket.keys))[indexPath.section]
            cell.categoryText.textColor = .white
            cell.backgroundColor = colorArray[indexPath.section % 6]
            return cell
        } else {
            let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
            cell.delegate = self
            cell.delDelegate = self
            var collectionArray = [ProductModel]()
            for productX in self.myMarket["\((Array(self.myMarket.keys))[indexPath.section])"]! {
                collectionArray.append(productX)
            }
            cell.configure(with: collectionArray)
            return cell
        }
    }
    
    func tappedProductionCollection(products: [ProductModel]?, index: Int, didTappedInTableViewCell: ProductTableViewCell) {
        let vc = NewProductVC(product: products![index])
        self.present(vc, animated: true)
    }
    
    func deleteProductionCollection(products: [ProductModel]?, index: Int, didTappedInTableViewCell: ProductTableViewCell) {
        let alert = UIAlertController(title: "Are you sure?", message: "The product will delete!", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            DatabaseManager.shared.deleteProduct(productId: products![index].id) { success in
                if success {
                    StorageManager.shared.deletePhoto(name: products![index].productName) { success in
                        if success {
                            DispatchQueue.main.async {
                                self.reloadData()
                            }
                        }
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == categoryTableView {
            if indexPath.row == 0 {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == categoryTableView {
            if indexPath.row == 0 {
                return .delete
            } else {
                return .none
            }
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == categoryTableView {
            if indexPath.row == 0 {
                if editingStyle == .delete {
                    let willDeleteCategory = self.myMarket["\((Array(self.myMarket.keys))[indexPath.section])"]!
                    willDeleteCategory.forEach { product in
                        DatabaseManager.shared.deleteProduct(productId: product.id)
                        StorageManager.shared.deletePhoto(name: product.productName)
                    }
                    DispatchQueue.main.async {
                        self.reloadData()
                    }
                }
            }
        }
    }
}


