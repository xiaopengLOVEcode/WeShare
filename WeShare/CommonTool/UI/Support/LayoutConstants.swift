//
//  LayoutConstants.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/29.
//

import Foundation
import UIKit

public final class LayoutConstants {
    public static var screenSize: CGSize { return UIScreen.main.bounds.size }
    public static var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    public static var screenHeight: CGFloat { return UIScreen.main.bounds.height }
    public static var deviceWidth: CGFloat { Swift.min(screenWidth, screenHeight) }
    public static var deviceHeight: CGFloat { Swift.max(screenWidth, screenHeight) }
    
    public static var isIPhoneXSeriesScreenRatio: Bool { return Int((deviceHeight / deviceWidth) * 100) == 216 }
    public static var extraBottomPadding: CGFloat { return isIPhoneXSeriesScreenRatio ? 34 : 0 }
    
    public static var statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    public static var safeBottomHeight =  UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0
    
    public static var safeTopHeight =  UIWindow.keyWindow?.safeAreaInsets.top ?? 0
    
    public static var navigationBarHeight: CGFloat { return 44.0 }

    public static var topBarHeight: CGFloat {
        return Self.statusBarHeight + Self.navigationBarHeight
    }
    
    
    static func xp_tabBarHeight() -> CGFloat {
        return 49.0
    }
    
    /// 底部安全区高度
    static func xp_safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
    
    /// 底部导航栏高度（包括安全区）
    static func xp_tabBarFullHeight() -> CGFloat {
        return xp_tabBarHeight() + xp_safeDistanceBottom()
    }
}
