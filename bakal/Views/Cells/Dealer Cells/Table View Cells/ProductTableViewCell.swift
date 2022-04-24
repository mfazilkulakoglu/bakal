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
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductTableViewCell", bundle: nil)
    }
    
    func configure(with models: [ProductModel]) {
        self.models = models
        collectionView.reloadData()
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var models = [ProductModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(ProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        delegate?.tappedProductionCollection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
}
