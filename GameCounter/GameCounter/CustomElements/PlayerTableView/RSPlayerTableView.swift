//
//  RSPlayerTableView.swift
//  GameConter
//
//  Created by Kirill on 25.08.21.
//

import UIKit

class RSPlayerTableView: UITableView {
    
    init(frame: CGRect) {
        super.init(frame: .zero, style: .plain)
        self.layer.cornerRadius = 15
        self.backgroundColor = .clear
        self.separatorColor = .rsTableViewSeparator
        self.bounces = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
