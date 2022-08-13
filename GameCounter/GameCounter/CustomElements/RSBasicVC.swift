//
//  RSBasicVC.swift
//  GameConter
//
//  Created by Kirill on 26.08.21.
//

import UIKit

class RSBasicVC: UIViewController {
    
    var contentData = FillingData.data
    var titleLabel = RSTitleLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rsBackgroundMain
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupTitleLabel(withTitle title: String) {
        titleLabel.text = title
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addLabelConstraints()
    }
    
    func addLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46),
        ])
    }

}
