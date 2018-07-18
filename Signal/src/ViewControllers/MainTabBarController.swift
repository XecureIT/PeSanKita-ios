//
//  MainTabBarController.swift
//  PeSankita
//
//  Created by Albert Januar on 10/07/18.
//  Copyright © 2018 Open Whisper Systems. All rights reserved.
//

import UIKit

public final class MainTabBarController: UITabBarController {
    public var newlyRegisteredUser: Bool = false
    
    public override func viewDidLoad() {
        // Inbox
        let inboxViewController: SignalsViewController = SignalsViewController(cellType: .inboxState)
        inboxViewController.newlyRegisteredUser = newlyRegisteredUser
        
        let inboxNavigationController: SignalsNavigationController = SignalsNavigationController(rootViewController: inboxViewController)
        inboxNavigationController.tabBarItem.title = NSLocalizedString("WHISPER_NAV_BAR_TITLE", comment: "")
        inboxNavigationController.tabBarItem.image = UIImage(named: "ic_chat")!

        // Archive
        let archiveViewController: SignalsViewController = SignalsViewController(cellType: .archiveState)
        archiveViewController.newlyRegisteredUser = newlyRegisteredUser
        
        let archiveNavigationController: SignalsNavigationController = SignalsNavigationController(rootViewController: archiveViewController)
        archiveNavigationController.tabBarItem.title = NSLocalizedString("ARCHIVE_NAV_BAR_TITLE", comment: "")
        archiveNavigationController.tabBarItem.image = UIImage(named: "ic_archive")!

        // Setting
        let settingViewController: AppSettingsViewController = AppSettingsViewController()
        let settingNavigationController: OWSNavigationController = OWSNavigationController(rootViewController: settingViewController)
        settingNavigationController.tabBarItem.title = NSLocalizedString("SETTINGS_NAV_BAR_TITLE", comment: "")
        settingNavigationController.tabBarItem.image = UIImage(named: "ic_setting")!
        
        self.setViewControllers([inboxNavigationController, archiveNavigationController, settingNavigationController], animated: true)
        
        setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(showInbox), name: NSNotification.Name("showInbox"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showArchive), name: Notification.Name("showArchive"), object: nil)
    }
    
    @objc private func showInbox() {
        self.selectedIndex = 0
    }
    
    @objc private func showArchive() {
        self.selectedIndex = 1
    }
}
