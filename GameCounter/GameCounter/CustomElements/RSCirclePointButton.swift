//
//  RSCirclePointButton.swift
//  GameConter
//
//  Created by Kirill on 27.08.21.
//

import UIKit

enum CircleButtonSize {
    case small
    case big
}

class RSCirclePointButton: UIButton {
    
    private var radius: CGFloat = 0
    let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    init(title: String, size: CircleButtonSize) {
        super.init(frame: .zero)
        
        switch size {
        case .small:
            self.radius = 27.5
            titleLabel!.font = .rsExtraBold25
        case .big:
            self.radius = 45.0
            titleLabel!.font = .rsExtraBold40
        }
        
        setTitle(title, for: .normal)
        layer.backgroundColor = UIColor.rsGreen.cgColor
        layer.cornerRadius = radius
        
        hapticFeedback.prepare()
        
        configureTitle()
        activateDimensionConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitle() {
        guard let titleLabel = titleLabel else { return }
        setTitleColor(UIColor.rsLabelWhite.withAlphaComponent(1.0), for: .normal)
        setTitleShadowColor(UIColor.rsGreen.withAlphaComponent(0.5), for: .normal)
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowRadius = 0.0
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.masksToBounds = false
    }
    
    func activateDimensionConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        heightAnchor.constraint(equalToConstant: (radius * 2)),
        widthAnchor.constraint(equalToConstant: (radius * 2))
        ])
    }
    
    override var isHighlighted: Bool {
        didSet {
            if super.isHighlighted {
                hapticFeedback.impactOccurred()
                layer.backgroundColor = UIColor.rsGreen.withAlphaComponent(0.5).cgColor
            }
            else {
                layer.backgroundColor = UIColor.rsGreen.cgColor
            }
        }
    }
}
