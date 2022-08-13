//
//  RSTitleLabel.swift
//  GameConter
//
//  Created by Kirill on 25.08.21.
//

import UIKit

class RSTitleLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        self.font = UIFont.rsExtraBold36
        self.textColor = UIColor.rsLabelWhite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
