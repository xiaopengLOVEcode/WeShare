//
//  PLButton.swift
//  PowerLoans
//
//  Created by Neo on 2023/9/7.
//

import Foundation

public class PLButton: UIButton {
    
    public var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

public extension PLButton {
    func applyPLStyle() {
        let colors = [UIColor(hex: 0x100C12)]
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
       addObserver(self, forKeyPath: #keyPath(UIButton.isEnabled), options: [.new, .old], context: nil)
   }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        if keyPath == #keyPath(UIButton.isEnabled) {
            gradientLayer.opacity = isEnabled == true ? 1.0 : 0.5
        }
    }
    
}
