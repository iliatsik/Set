//
//  CollectionViewCell.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func onCardButton(sender: UIButton, index: Int)
    func firstUpdateView(index: Int, button: UIButton)
}

class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 32)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
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
    
    func configure(delegate: CollectionViewCellDelegate, at index: Int) {
        self.delegate = delegate
        button.tag = index
        button.addTarget(self, action: #selector(onCardButton(sender:)), for: .touchUpInside)
        
        if button.tag < 4 || button.tag > 15 { button.isHidden = true; button.isEnabled = false }
        self.delegate?.firstUpdateView(index: button.tag, button: button)
    }
    
    @objc private func onCardButton(sender: UIButton) {
        delegate?.onCardButton(sender: sender, index: sender.tag)
    }
}
