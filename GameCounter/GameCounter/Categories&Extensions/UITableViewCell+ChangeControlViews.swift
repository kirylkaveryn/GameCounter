//
//  UITableViewCell+ChangeControlViews.swift
//  GameConter
//
//  Created by Kirill on 26.08.21.
//

import UIKit

extension UITableViewCell {
    
    var reorderControl: UIImageView? {
        let reorderControl = self.subviews.first { view -> Bool in
            view.classForCoder.description() == "UITableViewCellReorderControl"
        }
        return reorderControl?.subviews.first { view -> Bool in
            view is UIImageView
        } as? UIImageView
    }
    
    var deleteControl: UIImageView? {
        let deleteControl = self.subviews.first { view -> Bool in
            view.classForCoder.description() == "UITableViewCellEditControl"
        }
        return deleteControl?.subviews.first { view -> Bool in
            view is UIImageView
        } as? UIImageView
    }
}

extension UIImageView {
    
    func tint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    func tintBackground(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.backgroundColor = color
    }
    
    
}
