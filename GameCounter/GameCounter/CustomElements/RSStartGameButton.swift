//
//  RSStartGameButton.swift
//  GameConter
//
//  Created by Kirill on 27.08.21.
//

import UIKit

class RSStartGameButton: UIButton {
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    init() {
        super.init(frame: .zero)
        configureButton()
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {
        layer.backgroundColor = UIColor.rsGreen.cgColor
        layer.cornerRadius = 30
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 0.0
        layer.shadowColor = UIColor.rsGreen.withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = 1.0
    }
    
    func configureTitle() {
        guard let titleLabel = titleLabel else { return }
        setTitle("Start game", for: .normal)
        setTitleColor(UIColor.rsLabelWhite.withAlphaComponent(1.0), for: .normal)
        setTitleShadowColor(UIColor.rsGreen.withAlphaComponent(0.5), for: .normal)
        titleLabel.font = .rsExtraBold24
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowRadius = 0.0
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.masksToBounds = false
    }
    
    func activateConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(startGameButtonConstraintsUp)
    }
    
    lazy var startGameButtonConstraintsUp = [
        leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: -65),
        heightAnchor.constraint(equalToConstant: 60) ]
    
    lazy var startGameButtonConstraintsDown = [
        leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: -60),
        heightAnchor.constraint(equalToConstant: 60) ]
    
    override var isHighlighted: Bool {
        didSet {
            if super.isHighlighted {
                hapticFeedback.impactOccurred()
                NSLayoutConstraint.deactivate(startGameButtonConstraintsUp)
                NSLayoutConstraint.activate(startGameButtonConstraintsDown)
                layer.shadowOffset = CGSize(width: 0, height: 0)
            }
            else {
                hapticFeedback.impactOccurred()
                NSLayoutConstraint.deactivate(startGameButtonConstraintsDown)
                NSLayoutConstraint.activate(startGameButtonConstraintsUp)
                layer.shadowOffset = CGSize(width: 0, height: 5)
            }
        }
    }
}


