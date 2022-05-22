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
    
//    public let addProductButton: UIButton = {
//       let button = UIButton()
//        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//        button.backgroundColor = .systemBackground
//        return button
//    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let buttonWidth = contentView.width / 4
//        addProductButton.frame = CGRect(x: (contentView.width - 5 - buttonWidth),
//                                        y: 10,
//                                        width: buttonWidth,
//                                        height: contentView.height - 20)
        categoryText.frame = CGRect(x: 20,
                                    y: 10,
                                    width: (contentView.width - 70),
                                    height: contentView.height - 20)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(categoryText)
//        contentView.addSubview(addProductButton)
        selectionStyle = .none
        
//        addProductButton.addTarget(self,
//                                   action: #selector(didTapAddCategoryButton),
//                                   for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func didTapAddCategoryButton() {
//        delegate?.tappedAddCategoryButton()
//    }
}


