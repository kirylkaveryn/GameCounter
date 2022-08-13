//
//  RSBottomIndexCollectionViewCell.swift
//  GameConter
//
//  Created by Kirill on 28.08.21.
//

import UIKit

enum IndexStateHighlited {
    case yes
    case no
}

class RSBottomIndexCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "RSBottomIndexCollectionViewCell"
    
    let playerLabel = UILabel()

    func configureCell(player: String, highlited: IndexStateHighlited) {
        layer.backgroundColor = UIColor.clear.cgColor
        contentMode = .center
        playerLabel.text = String(player.first!)
        playerLabel.font = .rsExtraBold20
        
        switch highlited {
        case .yes:
            playerLabel.textColor = .rsLabelWhite
        case .no:
            playerLabel.textColor = .rsBackgroundCollection
        }
        
        addSubview(playerLabel)
        playerLabel.frame = bounds
        
        activateConstriants()
    }

    func activateConstriants() {
        playerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playerLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        
    }
}
