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
        executeNormalLaunch(launchOptions: launchOptions)
        return true
    }
    
    func executeNormalLaunch(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        setupWindow(with: TabBarViewController())
    }
    
    private func setupWindow(with rootVC: UIViewController) {
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIDevice.width, height: UIDevice.height))
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
