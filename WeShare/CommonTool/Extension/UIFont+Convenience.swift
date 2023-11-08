

import Foundation
import UIKit

public extension UIFont {
    static func font(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize)
    }

    static func boldFont(_ fontSize: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
}
