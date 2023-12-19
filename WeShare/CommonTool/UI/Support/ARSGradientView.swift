

import UIKit

open class ARSGradientView: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        return layer
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(self.gradientLayer)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.masksToBounds = true
    }
    
    public func setStart(_ start: CGPoint, end: CGPoint) {
        self.gradientLayer.startPoint = start
        self.gradientLayer.endPoint = end
        self.gradientLayer.setNeedsDisplay()
    }
    
    public func setColors(_ colors: [UIColor]) {
        var cgColors: [CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        self.gradientLayer.colors = cgColors
        self.gradientLayer.setNeedsDisplay()
    }

}
