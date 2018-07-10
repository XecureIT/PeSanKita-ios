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
        inboxNavigationController.tabBarItem.image = UIImage(named: "ic_chat")!

        let settingViewController: AppSettingsViewController = AppSettingsViewController()
        let settingNavigationController: OWSNavigationController = OWSNavigationController(rootViewController: settingViewController)
        settingNavigationController.tabBarItem.title = "Setting"
        settingNavigationController.tabBarItem.image = UIImage(named: "ic_setting")!
        
        self.setViewControllers([inboxNavigationController, settingNavigationController], animated: true)
    }
}
