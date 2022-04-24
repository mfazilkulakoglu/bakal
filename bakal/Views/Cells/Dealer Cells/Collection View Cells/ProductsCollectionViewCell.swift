//
//  ProductsCollectionViewCell.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 21.04.2022.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelComment: UILabel!
    @IBOutlet var labelUnit: UILabel!
    @IBOutlet var labelUnitType: UILabel!
    @IBOutlet var labelPrice: UILabel!
    @IBOutlet var labelStatu: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    static let identifier = "ProductsCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: ProductModel) {
        self.labelName.text = model.productName
        self.labelComment.text = model.productComment
        self.labelUnit.text = String(model.productUnit)
        self.labelPrice.text = String(model.productPrice)
        self.labelStatu.text = String(model.productStatu)
        self.labelUnitType.text = model.productUnitType
        
    }

}
