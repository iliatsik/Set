//
//  CollectionViewCell.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var button : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .boldSystemFont(ofSize: 45)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = contentView.bounds
    }
}
