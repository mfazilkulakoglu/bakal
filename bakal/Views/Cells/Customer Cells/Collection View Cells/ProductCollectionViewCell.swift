//
//  ProductCollectionViewCell.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 24.05.2022.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    static let identifier = "ProductCollectionViewCell"
    
    private let productImage: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "house")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Test"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let commentLabel: UILabel = {
       let label = UILabel()
        label.text = "Test"
        label.textAlignment = .left
        label.backgroundColor = .systemBackground
        label.textRect(forBounds: CGRect(x: 5, y: 0, width: 0, height: 0), limitedToNumberOfLines: 1)
        return label
    }()
    
    private let unitLabel: UILabel = {
       let label = UILabel()
        label.text = "Deneme"
        label.textAlignment = .right
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let unitTypeLabel: UILabel = {
       let label = UILabel()
        label.text = "Deneme"
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.text = "Deneme"
        label.textAlignment = .right
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let priceTypeLabel: UILabel = {
       let label = UILabel()
        label.text = "€"
        label.textAlignment = .left
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let conditionLabel: UILabel = {
       let label = UILabel()
        label.text = "Deneme"
        label.textAlignment = .center
        label.backgroundColor = .systemRed
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8.0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(unitLabel)
        contentView.addSubview(unitTypeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceTypeLabel)
        contentView.addSubview(conditionLabel)
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 5,
                                 y: 10,
                                 width: contentView.width - 10,
                                 height: 20)
        conditionLabel.frame = CGRect(x: 5,
                                      y: contentView.height - 35,
                                      width: contentView.width - 10,
                                      height: 25)
        unitLabel.frame = CGRect(x: 5,
                                 y: conditionLabel.top - 35,
                                 width: (contentView.width / 3) - 10,
                                 height: 25)
        unitTypeLabel.frame = CGRect(x: unitLabel.right + 5,
                                     y: conditionLabel.top - 35,
                                     width: contentView.width / 6,
                                     height: 25)
        priceTypeLabel.frame = CGRect(x: contentView.width - 25,
                                      y: unitTypeLabel.top,
                                      width: 20,
                                      height: 25)
        priceLabel.frame = CGRect(x: unitTypeLabel.right + 5,
                                  y: unitTypeLabel.top,
                                  width: priceTypeLabel.left - unitTypeLabel.right - 10,
                                  height: 25)
        commentLabel.frame = CGRect(x: 5,
                                    y: unitTypeLabel.top - 35,
                                    width: contentView.width - 10,
                                    height: 25)
        productImage.frame = CGRect(x: 5,
                                    y: nameLabel.bottom + 5,
                                    width: contentView.width - 10,
                                    height: commentLabel.top - nameLabel.bottom - 15)
        
    }
    
    public func configure(with model: ProductModel) {
        self.nameLabel.text = model.productName
        self.commentLabel.text = model.productComment
        self.unitLabel.text = String(model.productUnit)
        self.priceLabel.text = String(model.productPrice)
        self.conditionLabel.text = String(model.productStatu)
        if self.conditionLabel.text == "Available" {
            self.conditionLabel.textColor = .white
            self.conditionLabel.backgroundColor = .systemGreen
        } else {
            self.conditionLabel.textColor = .white
            self.conditionLabel.backgroundColor = .systemRed
        }
        self.unitTypeLabel.text = model.productUnitType
        self.productImage.sd_setImage(with: URL(string: model.productPhoto))
        self.productImage.contentMode = .scaleAspectFill
    }

}
