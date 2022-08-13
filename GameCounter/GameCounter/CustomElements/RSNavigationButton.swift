//
//  RSNavigationButton.swift
//  GameConter
//
//  Created by Kirill on 26.08.21.
//

import UIKit

enum ButtonPosition {
    case left
    case rignt
}

class RSNavigationButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.rsGreen, for: .normal)
        self.setTitleColor(UIColor.rsGreen.withAlphaComponent(0.5), for: .highlighted)
        self.titleLabel?.font = .rsExtraBold17
    }
    
    func activateConstraints(position: ButtonPosition) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else {
            return
        }
        switch position {
        case .left:
            removeConstraints(self.constraints)
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                heightAnchor.constraint(equalToConstant: 41),
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: -7),
            ])
        case .rignt:
            removeConstraints(self.constraints)
            NSLayoutConstraint.activate([
                trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                heightAnchor.constraint(equalToConstant: 41),
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: -7),
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
