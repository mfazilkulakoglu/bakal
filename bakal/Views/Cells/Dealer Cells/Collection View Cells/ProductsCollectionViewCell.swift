//
//  ProductsCollectionViewCell.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 21.04.2022.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelComment: UILabel!
    @IBOutlet var labelUnit: UILabel!
    @IBOutlet var labelUnitType: UILabel!
    @IBOutlet var labelPrice: UILabel!
    @IBOutlet var labelStatu: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    
    var deleteThisCell: (() -> Void)?
    @IBAction func deletePressed(_ sender: Any) {
        deleteThisCell?()
    }
    
    
    static let identifier = "ProductsCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelStatu.layer.masksToBounds = true
        labelStatu.layer.cornerRadius = 6.0
        
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 8.0
        
    }
    
    public func configure(with model: ProductModel) {
        self.labelName.text = model.productName
        self.labelComment.text = model.productComment
        self.labelUnit.text = String(model.productUnit)
        self.labelPrice.text = String(model.productPrice)
        self.labelStatu.text = String(model.productStatu)
        if self.labelStatu.text == "Available" {
            self.labelStatu.textColor = .white
            self.labelStatu.backgroundColor = .systemGreen
        } else {
            self.labelStatu.textColor = .white
            self.labelStatu.backgroundColor = .systemRed
        }
        self.labelUnitType.text = model.productUnitType
        self.imageView.sd_setImage(with: URL(string: model.productPhoto)) 
        self.imageView.contentMode = .scaleAspectFill
    }

}
