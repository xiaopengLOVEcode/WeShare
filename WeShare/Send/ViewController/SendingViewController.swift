//
//  SendingViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/7.
//

import UIKit

final class SendingViewController: PLBaseViewController {
    
    private let pageStyle: PageStyle
    
    private let centerProgressLabel = UILabel().then {
        $0.text = "0%"
        $0.font = .boldSystemFont(ofSize: 48)
        $0.textColor = UIColor(hex: 0x000E1F)
    }
    
    private let progressView = ProgressView()
    
    private let tipLable = UILabel().then {
        $0.text = "数据传输中，请不要离开"
        $0.font = .font(14)
    }
    
    private let bottomBtn = GradientButton().then {
        $0.applyAriesStyle()
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.setTitle("取消发送", for: .normal)
        $0.setTitle("取消发送", for: .highlighted)
    }
    
    private lazy var infoView: InfoTopView = {
        let view = InfoTopView(style: pageStyle)
        view.layer.shadowOffset = CGSize(width: 0, height: 9)
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor(hex: 0x000000, alpha: 0.05).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 19
        return view
    }()
    
    init(style: PageStyle) {
        self.pageStyle = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        headerView.leftButton.isHidden = false
    }
    
    private func setupSubviews() {
        title = pageStyle.vcTitle
        headerView.leftButton.isHidden = false
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(119)
            make.top.equalToSuperview().offset(16)
        }
        
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(230)
            make.bottom.equalToSuperview().offset(-283)
        }
        
        contentView.addSubview(tipLable)
        tipLable.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-139)
        }
        
        contentView.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-77)
            make.width.equalTo(274)
            make.height.equalTo(46)
        }
        
        contentView.addSubview(centerProgressLabel)
        centerProgressLabel.snp.makeConstraints { make in
            make.center.equalTo(progressView)
        }
    }
}