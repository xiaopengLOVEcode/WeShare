

import UIKit

extension UIView {
    @objc public var x: CGFloat {
        set { left = newValue }
        get { return left }
    }

    @objc public var left: CGFloat {
        set { frame.origin.x = newValue }
        get { return frame.origin.x }
    }

    @objc public var y: CGFloat {
        set { top = newValue}
        get { return top }
    }

    @objc public var top: CGFloat {
        set { frame.origin.y = newValue }
        get { return frame.origin.y }
    }

    @objc public var right: CGFloat {
        set { frame.origin.x = newValue - width }
        get { return left + width }
    }

    @objc public var bottom: CGFloat {
        set { frame.origin.y = newValue - height }
        get { return top + height }
    }

    @objc public var size: CGSize {
        set { frame.size = newValue }
        get { return frame.size }
    }

    @objc public var width: CGFloat {
        set { frame.size.width = newValue }
        get { return frame.size.width }
    }

    @objc public var height: CGFloat {
        set { frame.size.height = newValue }
        get { return frame.size.height }
    }

    @objc public var centerX: CGFloat {
        set { center.x = newValue}
        get { return center.x }
    }

    @objc public var centerY: CGFloat {
        set { center.y = newValue}
        get { return center.y }
    }
    
    @objc public var origin: CGPoint {
        set { frame.origin = newValue }
        get { return frame.origin }
    }
}
