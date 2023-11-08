
import Foundation

public extension UIButton {
    
    /// 设置图片文字间距
    /// - Parameters:
    ///   - spacing: 间距
    ///   - reversed: 图片文字位置翻转 (默认左图右文 )
    func setImageTitleSpacing(with spacing: CGFloat, reversed: Bool = false) {
        let inset = spacing * 0.5
        contentEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: -inset)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -inset, bottom: 0, right: inset)

        if reversed {
            transform = CGAffineTransform(scaleX: -1, y: 1)
            titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
            imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    /// 圆角设置为高度的一半
    func addHalfRadius() {
        addObserver(self, forKeyPath: #keyPath(UIButton.bounds), options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIButton.bounds) {
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
        }
    }

}
