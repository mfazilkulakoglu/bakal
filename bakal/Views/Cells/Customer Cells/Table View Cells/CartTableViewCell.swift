//
//  CartTableViewCell.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 27.05.2022.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    static let identifier = "CartTableViewCell"
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Test"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 16)
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let unitLabel: UILabel = {
       let label = UILabel()
        label.text = "Deneme"
        label.textAlignment = .left
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let unitTypeLabel: UILabel = {
       let label = UILabel()
        label.text = "Deneme"
        label.textAlignment = .left
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
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(unitLabel)
        contentView.addSubview(unitTypeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceTypeLabel)
        contentView.backgroundColor = .systemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        priceTypeLabel.frame = CGRect(x: contentView.width - 20,
                                      y: 5,
                                      width: 15,
                                      height: 40)
        priceLabel.frame = CGRect(x: priceTypeLabel.left - 60,
                                  y: 5,
                                  width: 55,
                                  height: 40)
        unitTypeLabel.frame = CGRect(x: priceLabel.left - 40,
                                     y: 5,
                                     width: 35,
                                     height: 40)
        unitLabel.frame = CGRect(x: unitTypeLabel.left - 60,
                                 y: 5,
                                 width: 55,
                                 height: 40)
        nameLabel.frame = CGRect(x: 5,
                                 y: 5,
                                 width: unitLabel.left - 10,
                                 height: 40)
        
    }
    
    public func configure(with model: ChosenProduct) {
        self.nameLabel.text = model.name
        self.unitLabel.text = model.unit
        self.priceLabel.text = model.price
        self.unitTypeLabel.text = model.unitType
    }
}
