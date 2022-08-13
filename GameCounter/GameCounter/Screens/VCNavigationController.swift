//
//  VCNavigationController.swift
//  RSSchool_T10
//
//  Created by Kirill on 25.08.21.
//

import UIKit

class VCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        // Do any additional setup after loading the view.
    }
    
    func setupNavigationItems() {
        setNeedsStatusBarAppearanceUpdate()
        navigationBar.barTintColor = UIColor.rsBackgroundMain
        navigationBar.isTranslucent = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

}
