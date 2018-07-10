//
//  MainTabBarController.swift
//  PeSankita
//
//  Created by Albert Januar on 10/07/18.
//  Copyright © 2018 Open Whisper Systems. All rights reserved.
//

import UIKit

public final class MainTabBarController: UITabBarController {
    
    public override func viewDidLoad() {
        let homeViewController: SignalsViewController = SignalsViewController()
        let inboxNavigationController: SignalsNavigationController = SignalsNavigationController(rootViewController: homeViewController)
        inboxNavigationController.tabBarItem.title = "Inbox"

        let settingViewController: AppSettingsViewController = AppSettingsViewController()
        let settingNavigationController: OWSNavigationController = OWSNavigationController(rootViewController: settingViewController)
        settingNavigationController.tabBarItem.title = "Setting"
        
        self.setViewControllers([inboxNavigationController, settingNavigationController], animated: true)
    }
}
