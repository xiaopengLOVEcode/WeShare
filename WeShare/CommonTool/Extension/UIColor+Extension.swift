//
//  UIColor+Extension.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/27.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(hex: UInt) {
        self.init(hex: hex, alpha: 1.0)
    }

    convenience init(hex: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }

    static func hex(_ hex: UInt) -> UIColor {
        return UIColor(hex: hex)
    }

    func alpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }

}

public extension UIColor {
    static let pl_title                  = UIColor(hex: 0x1D222C)
    static let pl_subTitle               = UIColor(hex: 0xA4A7AC)
    static let pl_main                   = UIColor(hex: 0x00D98C)
}
