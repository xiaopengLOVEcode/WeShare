//
//  AppDelegate.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        executeNormalLaunch(launchOptions: launchOptions)
        return true
    }
    
    private func setupWindow() {
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIDevice.width, height: UIDevice.height))
        window?.frame = UIScreen.main.bounds
    }
    
    /// 显示首页
    func setupTabBarViewController() {
        let tabbarViewController = TabBarViewController()
        setupRootViewController(with: tabbarViewController)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func executeNormalLaunch(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let showFlag = UserDefaults.standard.bool(forKey: "UserGuide")
        guard showFlag else {
            UserDefaults.standard.set(true, forKey: "UserGuide")
            let welcomeVC = WelcomeViewController()
            welcomeVC.dismissAction = { [weak self]  in
                guard let self = self else { return }
                self.setupTabBarViewController()
            }
            setupRootViewController(with: welcomeVC)
            return
        }
        setupTabBarViewController()
    }
    
    func setupRootViewController(with rootVC: UIViewController) {
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}
