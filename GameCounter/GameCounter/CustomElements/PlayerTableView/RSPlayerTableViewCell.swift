//
//  RSPlayerTableViewCell.swift
//  GameConter
//
//  Created by Kirill on 25.08.21.
//

import UIKit

class RSPlayerTableViewCell: UITableViewCell {
    
    static let reuseID = "RSPlayerTableViewCell"
    
    let deleteButton: UIImageView = {
        let image = UIImageView.init(image: UIImage(named: "icon_Delete"))
        image.tintColor = .rsRed
        return image
    }()
    
    let accessoryImage: UILabel = {
        let image = UILabel()
        image.backgroundColor = .clear
        image.textColor = .rsLabelWhite
        image.font = .rsExtraBold20
        image.textAlignment = .right
        return image
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell() {
        guard let textLabel = self.textLabel else {
            self.textLabel?.text = ""
            return
        }
        backgroundColor = .rsBackgroundCollection
        textLabel.textColor = .rsLabelWhite
        textLabel.font = .rsExtraBold20
        
        showsReorderControl = true
        
        accessoryView = accessoryImage
        accessoryImage.sizeToFit()
    }
    func setProgressScore(point: Int) {
        if point > 0 {
            accessoryImage.text = "+" + String(point)
        } else {
            accessoryImage.text = String(point)
        }
    }
    
    func addDeleteButton() {
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            deleteButton.heightAnchor.constraint(equalToConstant: 25),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
        ])
    }

}
