//
//  AppNavigationBarViewController.swift
//  PasswordKeeper
//
//  Created by Tyler Rockwood on 3/5/16.
//  Copyright © 2016 Rose-Hulman. All rights reserved.
//

import UIKit
import Material

class AppNavigationBarViewController: ToolbarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareNavigationBarView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// Prepares view.
    override func prepareView() {
        super.prepareView()
        view.backgroundColor = MaterialColor.black
    }
    
    /// Prepares the toolbar.
    private func prepareNavigationBarView() {
        // Title label.
        toolbar.titleLabel.text = "Password Keeper"
        toolbar.titleLabel.textAlignment = .Left
        toolbar.titleLabel.textColor = MaterialColor.white
        toolbar.titleLabel.font = RobotoFont.regular
        toolbar.backgroundColor = MaterialColor.indigo.base

        // Logout Button
        let image = UIImage(named: "logout")
        let logoutButton: FlatButton = FlatButton()
//        logoutButton.pulseColor = nil
        logoutButton.setImage(image, forState: .Normal)
        logoutButton.setImage(image, forState: .Highlighted)
      logoutButton.addTarget(appDelegate, action: #selector(AppDelegate.handleLogout), forControlEvents: .TouchUpInside)
        toolbar.rightControls = [logoutButton]
    }
}