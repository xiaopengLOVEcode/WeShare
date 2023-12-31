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
import CoreTelephony
import Network


class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarStyle()
        setupSubViewControllers()
        requestFunc()
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
    
    private func requestFunc() {
        
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { [weak self] status in
            guard let self = self else { return }
            if status == .notRestricted {
                // self.reportSuccess()
                return
            }
        }
        
        let monitor = NWPathMonitor()

        monitor.pathUpdateHandler = { path in
//            if path.localNetworkStatus == .satisfied {
//                print("已授权局域网权限")
//            } else {
//                print("未授权局域网权限")
//            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}
