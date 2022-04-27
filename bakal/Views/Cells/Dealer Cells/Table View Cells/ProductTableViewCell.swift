//
//  ProductTableViewCell.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 21.04.2022.
//

import UIKit

protocol ProductTableViewCellDelegate: AnyObject {
    func tappedProductionCollection()
}

class ProductTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    static let identifier = "ProductTableViewCell"
    
    weak var delegate: ProductTableViewCellDelegate?
    
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
//        let gestureRec = UITapGestureRecognizer(target: self,
//                                                action: #selector(didTapCollViewCell))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        delegate?.tappedProductionCollection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
        cell.configure(with: self.models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
    func configure(with models: [ProductModel]) {
        self.models = models
        self.productsCollectionView.reloadData()
    }
}
