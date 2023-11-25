//
//  TabBarViewController.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/27.
//

import Contacts
import EventKit
import TZImagePickerController
import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarStyle()
        setupSubViewControllers()
        applyAllAuthority()
    }

    private func setupSubViewControllers() {
        let sendVc = SendViewController()
        sendVc.tabBarItem = createItem(with: .send, vc: sendVc, title: "旧机发送", imageName: "send")

        let receiveVc = ReceiveViewController()
        receiveVc.tabBarItem = createItem(with: .recieve, vc: receiveVc, title: "新机接收", imageName: "receive")

        let settingVc = SettingViewController()
        settingVc.tabBarItem = createItem(with: .setting, vc: settingVc, title: "设置", imageName: "setting")

        var tabArray: [UIViewController] = [sendVc, receiveVc, settingVc]

        tabArray = tabArray.map { vc -> UINavigationController in
            vc.hidesBottomBarWhenPushed = false
            return UINavigationController(rootViewController: vc)
        }
        viewControllers = tabArray
    }

    private func applyAllAuthority() {
        // 申请相册权限
        if !TZImageManager.default().authorizationStatusAuthorized() {
            return
        }

        // 获取通讯录权限
        requestContactsPermission()

        // 申请日历权限
        requestCalendarAccess()

        // 申请文档权限
    }

    private func setupTabBarStyle() {
        tabBar.backgroundColor = .clear
        tabBar.tintColor = UIColor.black
        tabBar.unselectedItemTintColor = UIColor(hex: 0xBCC1C6)
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.layer.shadowColor = UIColor(hex: 0x000000).cgColor
        tabBar.layer.shadowOpacity = 0.03
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 2
    }

    private func createItem(with page: TabBarItem.Page, vc: UIViewController, title: String, imageName: String) -> UITabBarItem {
        let item = TabBarItem(
            page: page,
            vc: vc,
            title: title,
            image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        )

        item.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor(hex: 0xBCC1C6),
                NSAttributedString.Key.font: UIFont.font(10),
            ],
            for: .normal
        )
        item.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.font(10),
            ],
            for: .selected
        )
        return item
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}

extension TabBarViewController {
    func requestCalendarAccess() {
        let eventStore = EKEventStore()
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            break
        case .denied, .restricted:
            showPermissionAlert()
        case .notDetermined:
            eventStore.requestAccess(to: .reminder) { _, _ in
            }
        default:
            print()
        }
    }
}

extension TabBarViewController {
    func requestContactsPermission() {
        let contactStore = CNContactStore()

        // 检查是否已经授权
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            // 已经授权，可以访问通讯录
            break
        case .denied, .restricted:
            // 用户拒绝或受限制，弹出提示或者引导用户打开设置中的权限
            showPermissionAlert()
        case .notDetermined:
            // 请求授权
            contactStore.requestAccess(for: .contacts) { granted, _ in
                if !granted {
                    self.showPermissionAlert()
                }
            }
        default:
            break
        }
    }

    func showPermissionAlert() {
        // 在这里显示一个提示，引导用户打开设置中的权限
        let alertController = UIAlertController(
            title: "Permission Required",
            message: "Please grant permission to access contacts in Settings.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))

        present(alertController, animated: true, completion: nil)
    }
}
