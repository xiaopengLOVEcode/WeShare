//
//  ReceiveViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import UIKit
import YYText
import SGQRCode

class ReceiveViewController: PLBaseViewController {
    private let titleLable = UILabel().then {
        $0.text = "1、请在旧手机上打开“换机助手>发送文件"
        $0.font = .font(16)
        $0.textColor = UIColor(hex: 0x1D222C)
    }

    private lazy var bottomLabel: YYLabel = {
        let otherPrivacyLabel = YYLabel()
        otherPrivacyLabel.numberOfLines = 2
        otherPrivacyLabel.attributedText = {
            let content = """
            2、未安装换机助手，点击下载安装或者去应
            用市场搜索换机助手进行安装
            """
            let attributedText = NSMutableAttributedString(string: content)
            attributedText.yy_setColor(.hex(0x1D222C), range: content.nsrange(of: "2、未安装换机助手，"))
            attributedText.yy_setColor(.hex(0x1D222C), range: content.nsrange(of: "安装或者去应用市场搜索换机助手进行安装"))
            attributedText.yy_setColor(UIColor.pl_main, range: content.nsrange(of: "下载安装"))
            attributedText.yy_setFont(.font(16), range: attributedText.yy_rangeOfAll())
            attributedText.yy_setTextHighlight(content.nsrange(of: "下载安装"), color: nil, backgroundColor: nil) { [weak self] _, _, _, _ in
                self?.downLoadFunc()
            }
            return attributedText
        }()
        return otherPrivacyLabel
    }()

    private let imageWrapper = UIView().then {
        $0.layer.cornerRadius = 21
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: 0x000E1F, alpha: 0.12).cgColor
    }

    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "新机接收"
        setupSubviews()
        DispatchQueue.main.async {
            TransferTaskManager.shared.startlisten()
        }
    }

    private func setupSubviews() {
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.equalToSuperview().offset(68)
        }

        contentView.addSubview(imageWrapper)
        imageWrapper.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLable.snp.bottom).offset(50)
            make.left.equalTo(titleLable)
            make.right.equalTo(titleLable)
            make.height.equalTo(317)
        }

        imageWrapper.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7))
            make.center.equalToSuperview()
        }

        contentView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(imageWrapper.snp.bottom).offset(41)
            make.left.equalTo(titleLable)
            make.right.equalTo(titleLable)
        }
        
        let qrSize = LayoutConstants.deviceWidth - 70 - 14
        let qrImage = SGGenerateQRCode.generateQRCode(withData: "换机助手", size: qrSize)
        imageView.image = qrImage
    }
    
    private func downLoadFunc() {
        
    }
}
