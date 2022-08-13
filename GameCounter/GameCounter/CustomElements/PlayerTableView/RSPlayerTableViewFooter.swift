//
//  RSPlayerTableViewCellFooter.swift
//  GameConter
//
//  Created by Kirill on 26.08.21.
//

import UIKit

class RSPlayerTableViewFooter: UITableViewHeaderFooterView {
    
    static let reuseID = "RSPlayerTableViewFooter"

    let circleButton: UIImageView = {
        let image = UIImageView.init(image: UIImage(named: "icon_Add"))
        image.tintColor = .rsGreen
        return image
    }()
    
    let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add player"
        label.textColor = UIColor.rsGreen
        label.font = UIFont.rsSemiBold16
        return label
    }()

    func configureContent() {
        
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.cornerRadius = 15
        clipsToBounds = true
        contentView.backgroundColor = UIColor.rsBackgroundCollection
        
        circleButton.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(footerPressDown), for: .touchDown)
        button.addTarget(self, action: #selector(footerPressUp), for: .touchUpInside)

        contentView.addSubview(button)
        contentView.addSubview(titleLabel)
        contentView.addSubview(circleButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 56),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            circleButton.heightAnchor.constraint(equalToConstant: 25),
            circleButton.widthAnchor.constraint(equalToConstant: 25),
            
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    @objc func footerPressDown() {
        contentView.backgroundColor = .darkGray
    }
    
    @objc func footerPressUp() {
        contentView.backgroundColor = .rsBackgroundCollection
    }
}
