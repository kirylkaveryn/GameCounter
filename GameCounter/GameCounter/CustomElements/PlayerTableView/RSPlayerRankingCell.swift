//
//  RSPlayerRankingCell.swift
//  GameConter
//
//  Created by Kirill on 29.08.21.
//

import UIKit

class RSPlayerRankingCell: UITableViewCell {

    static let reuseID = "RSPlayerRankingCell"
    
    let rankPosition: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .rsLabelWhite
        label.font = .rsExtraBold28
        label.textAlignment = .left
        return label
    }()
    
    
    let accessoryImage: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .rsLabelWhite
        label.font = .rsExtraBold28
        label.textAlignment = .right
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell() {
        guard let textLabel = self.textLabel else {
            self.textLabel?.text = ""
            return
        }
        backgroundColor = .rsBackgroundMain
        
        textLabel.textColor = .rsYellow
        textLabel.font = .rsExtraBold28

        contentView.addSubview(rankPosition)
        rankPosition.sizeToFit()
        
        accessoryView = accessoryImage
        accessoryImage.sizeToFit()
        
        rankPosition.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rankPosition.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            rankPosition.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            textLabel.leadingAnchor.constraint(equalTo: rankPosition.trailingAnchor, constant: 10),
        ])
    }

}
