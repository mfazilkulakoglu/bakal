//
//  MyStoreMainCell.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 13.04.2022.
//

import UIKit

protocol MyStoreCategoryTVCellDelegate: AnyObject {
    func tappedAddCategoryButton()
}

class MyStoreCategoryTVCell: UITableViewCell {

   static let identifier = "MyStoreCategoryTVCell"
    
    weak var delegate: MyStoreCategoryTVCellDelegate?

    public let categoryText: UILabel = {
       let field = UILabel()
        return field
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        categoryText.frame = CGRect(x: 20,
                                    y: 10,
                                    width: (contentView.width - 70),
                                    height: contentView.height - 20)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(categoryText)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


