//
//  RSBottomIndexCollectionView.swift
//  GameConter
//
//  Created by Kirill on 28.08.21.
//

import UIKit

class RSBottomIndexCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var indexOfMajorCell = 0
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = .clear
        allowsSelection = false
        showsHorizontalScrollIndicator = false
        
        self.delegate = self
        self.dataSource = self
        
        register(RSBottomIndexCollectionViewCell.self, forCellWithReuseIdentifier: RSBottomIndexCollectionViewCell.reuseID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FillingData.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RSBottomIndexCollectionViewCell.reuseID, for: indexPath) as! RSBottomIndexCollectionViewCell
        if indexPath.item == indexOfMajorCell {
            cell.configureCell(player: FillingData.data[indexPath.item].name, highlited: .yes)
        }
        else {
            cell.configureCell(player: FillingData.data[indexPath.item].name, highlited: .no)
        }
        centerCollectionView()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let letter = String(FillingData.data[indexPath.item].name.first!)
        let letterWidth = CGSize(width: NSString(string: letter).size(withAttributes: .some([NSAttributedString.Key.font : UIFont.rsExtraBold20!])).width + 5, height: collectionView.frame.height)
        return letterWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func centerCollectionView() {
        superview!.layoutIfNeeded()
        let lastCellPosition = layoutAttributesForItem(at: IndexPath(item: FillingData.data.count - 1, section: 0))!.frame
        let lastCellXPosition = convert(lastCellPosition, from: self)
        let center = (contentSize.width - lastCellXPosition.maxX) / 2
        setContentOffset(CGPoint(x: -center, y: 0), animated: false)
    }

}

