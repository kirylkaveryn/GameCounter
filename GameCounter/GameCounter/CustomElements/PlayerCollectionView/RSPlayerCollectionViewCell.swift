//
//  RSPlayerCollectionViewCell.swift
//  GameConter
//
//  Created by Kirill on 27.08.21.
//

import UIKit

class RSPlayerCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "RSPlayerCollectionViewCell"
    
    let playerLabel = UILabel()
    var pointsLabel = UILabel()
    
    func configureCell(player: String, points: Int) {
        layer.backgroundColor = UIColor.rsBackgroundCollection.cgColor
        layer.cornerRadius = 15
        playerLabel.text = player
        playerLabel.font = .rsExtraBold28
        playerLabel.textColor = .rsYellow
        
        pointsLabel.text = String(points)
        pointsLabel.font = .rsBold100
        pointsLabel.textColor = .rsLabelWhite
        
        addSubview(playerLabel)
        addSubview(pointsLabel)
        
        activateConstriants()
    }

    
    func activateConstriants() {
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 23),

            pointsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pointsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
        ])
    }
}
