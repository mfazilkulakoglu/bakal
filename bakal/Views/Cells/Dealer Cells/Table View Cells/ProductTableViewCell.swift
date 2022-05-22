//
//  ProductTableViewCell.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 21.04.2022.
//

import UIKit

protocol ProductTableViewCellDelegate: AnyObject {
    func tappedProductionCollection(products: [ProductModel]?, index: Int, didTappedInTableViewCell: ProductTableViewCell)
}

protocol ProductTableViewCellDeleteDelegate: AnyObject {
    func deleteProductionCollection(products: [ProductModel]?, index: Int, didTappedInTableViewCell: ProductTableViewCell)
}

class ProductTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    static let identifier = "ProductTableViewCell"
    
    weak var delegate: ProductTableViewCellDelegate?
    weak var delDelegate: ProductTableViewCellDeleteDelegate?
    
    var models = [ProductModel]()
    
    @IBOutlet var productsCollectionView: UICollectionView!
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductTableViewCell", bundle: nil)
    }
      
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productsCollectionView.register(ProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.isUserInteractionEnabled = true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.tappedProductionCollection(products: models, index: indexPath.item, didTappedInTableViewCell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
        cell.configure(with: self.models[indexPath.row])
        cell.deleteThisCell = { [self] in
            self.delDelegate?.deleteProductionCollection(products: self.models, index: indexPath.item, didTappedInTableViewCell: self)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
    func configure(with models: [ProductModel]) {
        DispatchQueue.main.async {
            let sortedModels = models.sorted(by: { $0.date < $1.date })
            self.models = sortedModels
            print(self.models)
            self.productsCollectionView.reloadData()
        }
    }
}
