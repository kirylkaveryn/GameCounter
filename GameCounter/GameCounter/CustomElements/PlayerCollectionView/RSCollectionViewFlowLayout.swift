//
//  RSCollectionViewFlowLayout.swift
//  GameConter
//
//  Created by Kirill on 27.08.21.
//

import UIKit

class RSCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView as? RSPlayerCollectionView else { return proposedContentOffset }
        
        let pageWidth = 255 + minimumLineSpacing
        
        let currentXOffset = collectionView.contentOffset.x
        let nextXOffset = proposedContentOffset.x
        let maxIndex = ceil(currentXOffset / pageWidth)
        let minIndex = floor(currentXOffset / pageWidth)

        var index: CGFloat = 0

        if nextXOffset > currentXOffset {
            index = maxIndex
        } else {
            index = minIndex
        }

        let xOffset = pageWidth * index
        let point = CGPoint(x: xOffset, y: 0)
        collectionView.indexOfMajorCell = index
        return point
      }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let elements = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        self.transformCell(cells: elements)
        return elements
    }

    func transformCell(cells: [UICollectionViewLayoutAttributes]) {
        guard let collectionView = collectionView as? RSPlayerCollectionView else { return }
        for cell in cells {
            if cell.indexPath != IndexPath(row: Int(collectionView.indexOfMajorCell), section: 0) {
            }
        }
    }

}
