//
//  UIDevice+Extension.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/27.
//

import Foundation
import UIKit

public extension UIDevice {
    static var width: CGFloat { min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) }

    static var height: CGFloat { max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) }
}
