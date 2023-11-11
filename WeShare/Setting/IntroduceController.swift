//
//  IntroduceController.swift
//  WeShare
//
//  Created by xialipeng on 2023/11/10.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit

final class IntroduceController: PLBaseViewController {
    
    private let bag = DisposeBag()
    
    private let returnBtn = UIButton().then {
        $0.setImage(UIImage(named: "return"), for: .normal)
        $0.setImage(UIImage(named: "return"), for: .highlighted)
    }
    
    private let titleLable = UILabel().then {
        $0.text = "换机助手"
        $0.font = .boldSystemFont(ofSize: 24)
    }
    
    private let subDescLabel = UILabel().then {
        $0.text = "零流量 一键换机"
        $0.font = .font(14)
    }
    
    private let bottomBtn = GradientButton().then {
        $0.applyAriesStyle()
        $0.setTitle("继续试用", for: .normal)
        $0.setTitle("继续试用", for: .highlighted)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let centerView = IntroduceCenterView()
    
    override func shouldHideHeaderView() -> Bool {
        return true
    }
    
    
    override func headerViewReturnButtonPressed(_ sender: Any?) {
        super.headerViewReturnButtonPressed(sender)
    }
    
    private let descLabel = UILabel().then {
        $0.text = "解锁高级版本，无使用次数，去除烦人的广告，新用户专享优惠免费试用3天，结束以后¥68.00/季，可自动订阅，如果对体验不满意，可随时取消."
        $0.font = .font(14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = UIColor(hex: 0x000000, alpha: 0.87)
    }
    
    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 32
    }
    
    private let polictBtn = UIButton().then {
        $0.setTitle("隐私政策", for: .normal)
        $0.setTitle("隐私政策", for: .highlighted)
        $0.setTitleColor(UIColor(hex: 0x808C88), for: .normal)
        $0.setTitleColor(UIColor(hex: 0x808C88), for: .highlighted)
        $0.titleLabel?.font = .font(12)
    }
    private let recoverBtn = UIButton().then {
        $0.setTitle("恢复订阅", for: .normal)
        $0.setTitle("恢复订阅", for: .highlighted)
        $0.setTitleColor(UIColor(hex: 0x808C88), for: .normal)
        $0.setTitleColor(UIColor(hex: 0x808C88), for: .highlighted)
        $0.titleLabel?.font = .font(12)
    }
    private let useBtn = UIButton().then {
        $0.setTitle("使用条款", for: .normal)
        $0.setTitle("使用条款", for: .highlighted)
        $0.setTitleColor(UIColor(hex: 0x808C88), for: .normal)
        $0.setTitleColor(UIColor(hex: 0x808C88), for: .highlighted)
        $0.titleLabel?.font = .font(12)
    }

    private let gradientView = ARSGradientView().then {
        $0.setColors([UIColor(hex: 0xE6F4EF), UIColor.white])
        $0.setStart(CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1))
    }
    
    private let backImageView = UIImageView().then {
        $0.image = UIImage(named: "shareBigBack")
    }
    
    private let switchBar = SwitchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        addHandleEvent()
    }

    private func setupViews() {
        
        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(352)
        }
        
        gradientView.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30 + LayoutConstants.safeTopHeight)
            make.centerX.equalToSuperview()
        }
        
        gradientView.addSubview(subDescLabel)
        subDescLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    
        gradientView.addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subDescLabel.snp.bottom).offset(20)
            make.height.equalTo(174)
            make.width.equalTo(216)
        }
        
        contentView.addSubview(returnBtn)
        returnBtn.snp.makeConstraints { make in
            make.height.width.equalTo(26)
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(10 + LayoutConstants.safeTopHeight)
        }
        
        contentView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gradientView.snp.bottom).offset(26)
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalTo(centerView)
            make.top.equalTo(centerView.snp.bottom).offset(20)
        }
        
        contentView.addSubview(switchBar)
        switchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(24)
            make.height.equalTo(48)
            make.left.right.equalTo(descLabel)
        }
        
        contentView.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(switchBar.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
        }
        
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bottomBtn.snp.bottom).offset(24)
        }
        
        [polictBtn, recoverBtn, useBtn].forEach { itemBtn in
            hStackView.addArrangedSubview(itemBtn)
        }
    }

    private func addHandleEvent() {
        returnBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.headerViewReturnButtonPressed(nil)
        }.disposed(by: bag)
        
        bottomBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
        }.disposed(by: bag)
        
        polictBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
        }.disposed(by: bag)
        
        recoverBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
        }.disposed(by: bag)
        
        useBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
        }.disposed(by: bag)
    }
}
