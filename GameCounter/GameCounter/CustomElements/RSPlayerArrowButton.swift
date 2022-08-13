//
//  RSPlayerArrowButton.swift.swift
//  GameConter
//
//  Created by Kirill on 27.08.21.
//

import UIKit

enum PlayerStyle {
    case playLeft
    case playRight
    case stopLeft
    case stopRight
}

class RSPlayerArrowButton: UIButton {
    
    var viewMode: PlayerStyle?

    init(playerStyle: PlayerStyle) {
        super.init(frame: .zero)
        setStyle(style: playerStyle)
        contentMode = .scaleAspectFit
        activateDimensionConstraints()
    }

    func setStyle(style: PlayerStyle) {
        switch style {
        case .playLeft:
            setImage(UIImage(named: "icon_Next_left"), for: .normal)
        case .playRight:
            setImage(UIImage(named: "icon_Next_right"), for: .normal)
        case .stopLeft:
            setImage(UIImage(named: "icon_Previous_left"), for: .normal)
        case .stopRight:
            setImage(UIImage(named: "icon_Previous_right"), for: .normal)
        }
        sizeToFit()
    }
    
    func activateDimensionConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        heightAnchor.constraint(equalToConstant: 30),
        widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

