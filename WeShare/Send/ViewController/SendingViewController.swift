//
//  SendingViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/7.
//

import UIKit
import RxSwift
import RxCocoa

final class SendingViewController: PLBaseViewController {
    
    private let bag = DisposeBag()
    
    private let pageStyle: PageStyle
    
    private var centerProgressLabel = UILabel().then {
        $0.text = "0%"
        $0.font = .boldSystemFont(ofSize: 48)
        $0.textColor = UIColor(hex: 0x000E1F)
    }
    
    private let progressView = ProgressView()
    
    private let tipLable = UILabel().then {
        $0.text = "数据传输中，请不要离开"
        $0.font = .font(14)
    }
    
    private lazy var bottomBtn: GradientButton = {
        let btn = GradientButton()
        btn.applyAriesStyle()
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.setTitle(pageStyle.bottomText, for: .normal)
        btn.setTitle(pageStyle.bottomText, for: .highlighted)
        return btn
    }()
    
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
        addHandleEvent()
        headerView.leftButton.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwapDataManager.shared.stopServices()
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
            make.center.equalToSuperview()
            make.width.height.equalTo(230)
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
    
    private func addHandleEvent() {
        bottomBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: bag)
    }
    
    func update(with size: Double, time: String) {
        infoView.update(with: size, time: time)
    }
    
    func setProgress(with progress: Double) {
        self.centerProgressLabel.text = "\(Int(progress * 100))%"
        progressView.setProgress(Int(progress * 100), animated: true)
    }
}
