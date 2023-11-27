//
//  QRCodeViewController.swift
//  Aries
//
//  Created by 王昱 on 2021/6/7.
//

import AVFoundation
import Foundation
import SnapKit
import Then
import YYText
import SGQRCode

final class QRCodeViewController: PLBaseViewController {
    let tipLabel = UILabel().then {
        $0.text = "1、请在新手机上打开“换机助手>新机接收”\n生成二维码。"
        $0.font = .font(16)
        $0.textColor = .white
    }

    private let gradientView = ARSGradientView().then {
        $0.setColors([UIColor(hex: 0x00D98C, alpha: 0.0), UIColor(hex: 0x00D98C, alpha: 0.53)])
        $0.setStart(CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1))
    }
    
    private let scanner = SGScanCode()

    private lazy var bottomLabel: YYLabel = {
        let otherPrivacyLabel = YYLabel()
        otherPrivacyLabel.numberOfLines = 2
        otherPrivacyLabel.attributedText = {
            let content = """
            2、未安装换机助手，点击下载安装或者去应
            用市场搜索换机助手进行安装
            """
            let attributedText = NSMutableAttributedString(string: content)
            attributedText.yy_setColor(.hex(0xFFFFFF), range: content.nsrange(of: "2、未安装换机助手，点击"))
            attributedText.yy_setColor(.hex(0xFFFFFF), range: content.nsrange(of: "或者去应\n用市场搜索换机助手进行安装"))
            attributedText.yy_setColor(UIColor.pl_main, range: content.nsrange(of: "下载安装"))
            attributedText.yy_setFont(.font(16), range: attributedText.yy_rangeOfAll())
            attributedText.yy_setTextHighlight(content.nsrange(of: "下载安装"), color: nil, backgroundColor: nil) { [weak self] _, _, _, _ in
                self?.downLoadFunc()
            }
            return attributedText
        }()
        return otherPrivacyLabel
    }()

    private let foucusView = QRFocusView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "旧机发送"
        setupViews()
        startVerticalAnimation()
    }

    private func setupViews() {
        contentView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        headerView.backgroundView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        let leftBtn = headerView.leftButton
        leftBtn.setImage(UIImage(named: "white_return"), for: .normal)
        leftBtn.setImage(UIImage(named: "white_return"), for: .highlighted)
        headerView.titleLabel.textColor = .white
        let sideLenth = LayoutConstants.screenWidth - 70

        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(68)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
        }

        contentView.addSubview(foucusView)
        foucusView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLabel.snp.bottom).offset(45)
            make.width.height.equalTo(sideLenth)
        }

        foucusView.focusWrapper.addSubview(gradientView)
        foucusView.focusWrapper.clipsToBounds = true
        gradientView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(30)
        }

        headerView.leftButton.isHidden = false
        contentView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(foucusView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(tipLabel)
        }
    }

    func startVerticalAnimation() {
        contentView.layoutIfNeeded()
        contentView.setNeedsLayout()
        
        let animation = CABasicAnimation(keyPath: "position")
        let startPoint = gradientView.layer.position
        animation.fromValue = NSValue(cgPoint: CGPoint(x: startPoint.x, y: startPoint.y - 40))
        animation.isRemovedOnCompletion = false
        let endPoint = CGPoint(x: startPoint.x, y: startPoint.y + (LayoutConstants.screenWidth - 70))
        animation.toValue = NSValue(cgPoint: endPoint)
        animation.repeatCount = .infinity
        animation.duration = 2.0
        animation.delegate = self
        gradientView.layer.add(animation, forKey: "positionAnimation")
    }

    private func downLoadFunc() {
    }
}

extension QRCodeViewController: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {

    }
}
