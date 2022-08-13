//
//  PlayerCollectionView+DelegateAndData.swift
//  GameConter
//
//  Created by Kirill on 30.08.21.
//

import UIKit

// MARK: CollectionView DataSource
extension VCGame {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    FillingData.data.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RSPlayerCollectionViewCell.reuseID, for: indexPath) as! RSPlayerCollectionViewCell
    cell.configureCell(player: FillingData.data[indexPath.item].name, points: FillingData.data[indexPath.item].point)
    return cell
    }
}



// MARK: CollectionView Delegate
extension VCGame {
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: cellWidth, height: collectionView.frame.height)
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: (view.frame.width - cellWidth)/2, bottom: 0, right: (view.frame.width - cellWidth)/2)
}

func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    print("scrollViewDidScrollToTop")
}

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let collectionView = scrollView as? RSPlayerCollectionView else {return}
    if collectionView.contentOffset.x < -50 {
        collectionView.scrollToItem(at: IndexPath(row: FillingData.data.count - 1, section: 0), at: .centeredHorizontally, animated: true)
    }
        
    else if collectionView.contentOffset.x + cellWidth * 1.5 - 50 > collectionView.contentSize.width {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
        
    indexOfMajorCell = getIndexOfMajorCell(positionX: collectionView.contentOffset.x)
    collectionView.indexOfMajorCell = CGFloat(indexOfMajorCell)
    changePlayArrow(index: indexOfMajorCell)
}

func getIndexOfMajorCell(positionX: CGFloat) -> Int {
    let cellWidth: CGFloat = cellWidth + 20
    let offset = positionX / cellWidth
    let index = Int(round(offset))
    return index
    }
}


