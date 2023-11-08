import UIKit

final class ProgressView: UIView {
    struct Constant {
        // 进度条宽度
        static let lineWidth: CGFloat = 10
        // 进度槽颜色
        static let trackColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0,
                                        alpha: 1)
        // 进度条颜色
        static let progressColoar = UIColor.orange
    }

    // 进度槽
    let trackLayer = CAShapeLayer()
    // 进度条
    let progressLayer = CAShapeLayer()
    // 进度条路径（整个圆圈）
    let path = UIBezierPath()
    // 头部圆点
    var dot: UIView!

    // 进度条圆环中点
    var progressCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    // 进度条圆环中点
    var radius: CGFloat {
        return bounds.size.width / 2 - Constant.lineWidth
    }

    // 当前进度
    var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            } else if progress < 0 {
                progress = 0
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: .zero)
    }

    override func draw(_ rect: CGRect) {
        // 获取整个进度条圆圈路径
        path.addArc(withCenter: progressCenter, radius: radius,
                    startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)

        // 绘制进度槽
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = Constant.trackColor.cgColor
        trackLayer.lineWidth = Constant.lineWidth
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)

        // 绘制进度条
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = Constant.progressColoar.cgColor
        progressLayer.lineWidth = Constant.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        layer.addSublayer(progressLayer)

        // 绘制进度条头部圆点
        dot = UIView(frame: CGRect(x: 0, y: 0, width: Constant.lineWidth,
                                   height: Constant.lineWidth))
        let dotPath = UIBezierPath(ovalIn:
            CGRect(x: 0, y: 0, width: Constant.lineWidth, height: Constant.lineWidth)).cgPath
        let arc = CAShapeLayer()
        arc.lineWidth = 0
        arc.path = dotPath
        arc.strokeStart = 0
        arc.strokeEnd = 1
        arc.strokeColor = Constant.progressColoar.cgColor
        arc.fillColor = Constant.progressColoar.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.shadowRadius = 5.0
        arc.shadowOpacity = 0.5
        arc.shadowOffset = CGSize.zero
        dot.layer.addSublayer(arc)
        dot.layer.position = calcCircleCoordinateWithCenter(progressCenter,
                                                            radius: radius, angle: CGFloat(-progress) / 100 * 360 + 90)
        addSubview(dot)
    }

    // 设置进度（可以设置是否播放动画）
    func setProgress(_ pro: Int, animated anim: Bool) {
        setProgress(pro, animated: anim, withDuration: 0.55)
    }

    // 设置进度（可以设置是否播放动画，以及动画时间）
    func setProgress(_ pro: Int, animated anim: Bool, withDuration duration: Double) {
        let oldProgress = progress
        progress = pro

        // 进度条动画
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        CATransaction.commit()

        // 头部圆点动画
        let startAngle = angleToRadian(360 * Double(oldProgress) / 100 - 90)
        let endAngle = angleToRadian(360 * Double(progress) / 100 - 90)
        let clockWise = progress > oldProgress ? false : true
        let path2 = CGMutablePath()
        path2.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY),
                     radius: bounds.size.width / 2 - Constant.lineWidth,
                     startAngle: startAngle, endAngle: endAngle,
                     clockwise: clockWise, transform: transform)

        let orbit = CAKeyframeAnimation(keyPath: "position")
        orbit.duration = duration
        orbit.path = path2
        orbit.calculationMode = .cubicPaced
        orbit.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        orbit.isRemovedOnCompletion = false
        orbit.fillMode = .forwards
        dot.layer.add(orbit, forKey: "Move")
    }

    // 将角度转为弧度
    fileprivate func angleToRadian(_ angle: Double) -> CGFloat {
        return CGFloat(angle / Double(180.0) * .pi)
    }

    // 计算圆弧上点的坐标
    func calcCircleCoordinateWithCenter(_ center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
            let x2 = radius * CGFloat(cosf(Float(angle) * .pi / Float(180)))
            let y2 = radius * CGFloat(sinf(Float(angle) * .pi / Float(180)))
        return CGPoint(x: center.x + x2, y: center.y - y2)
    }
}
