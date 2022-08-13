//
//  RSPlayerTableViewHeader.swift
//  GameConter
//
//  Created by Kirill on 25.08.21.
//

import UIKit

class RSPlayerTableViewHeader: UITableViewHeaderFooterView {
    
    static let reuseID = "RSPlayerTableViewHeader"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContent(withTitle title: String) {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 15
        clipsToBounds = true
        
        contentView.backgroundColor = UIColor.rsBackgroundCollection
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.rsLabelGrey
        titleLabel.font = UIFont.rsSemiBold16
        titleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 0.15])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
        ])
    }

}
