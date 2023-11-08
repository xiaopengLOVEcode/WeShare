//

import UIKit

public class GradientButton: UIButton {
    
    public var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

public extension GradientButton {
     func applyAriesStyle(isGradient: Bool = false) {
        let colors =  [UIColor(hex: 0x00CF87).cgColor, UIColor(hex: 0x00F0AD).cgColor]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldFont(14)
        titleLabel?.text = "开始发送"
    }
}
