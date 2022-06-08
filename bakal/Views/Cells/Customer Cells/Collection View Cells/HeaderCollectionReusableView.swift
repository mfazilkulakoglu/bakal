//
//  HeaderCollectionReusableView.swift
//  bakal
//
//  Created by Mehmet  Kulakoğlu on 24.05.2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "header"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    public func configure(with name: String) {
        backgroundColor = .systemGreen
        addSubview(label)
        label.text = name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
