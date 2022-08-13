//
//  VCAddPlayer.swift
//  GameConter
//
//  Created by Kirill on 26.08.21.
//

import UIKit

class VCAddPlayer: RSBasicVC, UITextFieldDelegate {
    
    let navigationButtonBack = RSNavigationButton(title: "Back")
    let navigationButtonAdd = RSNavigationButton(title: "Add")
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .rsBackgroundCollection
        textField.font = .rsExtraBold24
        textField.textColor = .rsLabelWhite
        textField.tintColor = .rsLabelWhite
        textField.autocorrectionType = .no
        let padding = UIView(frame: CGRect.init(x: 0, y: 0, width: 24, height: 0))
        textField.leftView = padding
        textField.leftViewMode = .always
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleLabel(withTitle: "Add Player")
        setupNavigationItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = nil
        textField.attributedPlaceholder = NSAttributedString(string: "Player Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rsLabelGrey])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textField.becomeFirstResponder()
    }
    
    func setupNavigationItems() {
        view.addSubview(navigationButtonBack)
        view.addSubview(navigationButtonAdd)
        view.addSubview(textField)
        navigationButtonBack.activateConstraints(position: .left)
        navigationButtonAdd.activateConstraints(position: .rignt)
        activateTextFieldConstraints()
        
        textField.delegate = self
        
        navigationButtonBack.addTarget(self, action: #selector(navigationButtonLeftTapped), for: .touchUpInside)
        navigationButtonAdd.addTarget(self, action: #selector(navigationButtonRightTapped), for: .touchUpInside)
    }
    
    func activateTextFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 112),
            textField.heightAnchor.constraint(equalToConstant:60),
        ])
    }
    
    
    // MARK: Actions for buttons
    @objc func navigationButtonLeftTapped() {
        contentData = FillingData.data
        view.removeFromSuperview()
    }
    
    @objc func navigationButtonRightTapped() {
        guard let parentVC = parent as? VCGameCounter else {
            return
        }
        guard let newPlayer = textField.text else {
            navigationButtonLeftTapped()
            return
        }
        guard textField.text!.isEmpty == false else {
            return
        }
        contentData.append(DataItem(name: newPlayer, point: 0))
        parentVC.contentData = contentData
        parentVC.playersTableView.reloadData()
        parentVC.activateTableViewConstraints()
        
        view.removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationButtonRightTapped()
        return true
    }
}
