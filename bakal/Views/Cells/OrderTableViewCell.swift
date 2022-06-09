//
//  OrderTableViewCell.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 5.06.2022.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let identifier = "OrderTableViewCell"
    
    private let productNameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private let unitLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private let unitTypeLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private let priceTypeLabel: UILabel = {
       let label = UILabel()
        label.text = "€"
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        priceTypeLabel.frame = CGRect(x: contentView.width - 15,
                                      y: 5,
                                      width: 9,
                                      height: 40)
        priceLabel.frame = CGRect(x: priceTypeLabel.left - 65,
                                  y: 5,
                                  width: 60,
                                  height: 40)
        unitTypeLabel.frame = CGRect(x: priceLabel.left - 50,
                                     y: 5,
                                     width: 45,
                                     height: 40)
        unitLabel.frame = CGRect(x: unitTypeLabel.left - 55,
                                 y: 5,
                                 width: 50,
                                 height: 40)
        productNameLabel.frame = CGRect(x: 5,
                                        y: 5,
                                        width: unitLabel.left - 10,
                                        height: 40)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(priceTypeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(unitTypeLabel)
        contentView.addSubview(unitLabel)
        contentView.addSubview(productNameLabel)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: ChosenProduct) {
        self.productNameLabel.text = model.name
        self.unitLabel.text = model.unit
        self.unitTypeLabel.text = "\(model.unitType)  -->"
        self.priceLabel.text = model.price
        
        
    }

}
