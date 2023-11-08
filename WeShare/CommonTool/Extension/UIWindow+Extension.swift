//
//  UIWindow+Extension.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/27.
//

import Foundation
import UIKit

extension UIWindow {
    static var keyWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .last?.windows
                .first(where: { $0.isKeyWindow })
            
            if window == nil {
                window = UIApplication.shared.connectedScenes
                    .filter({ $0.activationState == .foregroundInactive })
                    .map({ $0 as? UIWindowScene })
                    .compactMap({ $0 })
                    .last?.windows
                    .first(where: { $0.isKeyWindow })
            }
        }
        if window == nil {
            window = UIApplication.shared.keyWindow
        }
        return window
    }
}
