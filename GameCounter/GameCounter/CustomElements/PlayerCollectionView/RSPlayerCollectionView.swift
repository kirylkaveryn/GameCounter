//
//  RSPlayerCollectionView.swift
//  GameConter
//
//  Created by Kirill on 27.08.21.
//

import UIKit

class RSPlayerCollectionView: UICollectionView {
    
    var indexOfMajorCell: CGFloat = 0
    
    init() {
        super.init(frame: .zero, collectionViewLayout: RSCollectionViewFlowLayout())
        backgroundColor = nil
        allowsSelection = false
        showsHorizontalScrollIndicator = false
        decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

