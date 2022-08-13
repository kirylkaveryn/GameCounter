//
//  RSDiceButton.swift
//  GameConter
//
//  Created by Kirill on 29.08.21.
//

import UIKit

class RSDiceButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        self.setImage(UIImage(named: "dice_4"), for: .normal)
        activateDimensionConstraints()
    }
    
    func activateDimensionConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        heightAnchor.constraint(equalToConstant: 30),
        widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
