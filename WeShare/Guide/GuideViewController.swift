//
//  GuideViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/9.
//

import UIKit
import RxSwift
import RxCocoa

final class WelcomeViewController: PLBaseViewController {
    
    private let bag = DisposeBag()
    
    var dismissAction: (() -> Void)?
    
    private let bottomBtn = GradientButton().then {
        $0.applyAriesStyle()
        $0.setTitle("下一步", for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private var currentIndex = 0
    
    private let guideArray: [GuideModel] = [
        GuideModel(title: "一键换机", desc: "轻松一点，换机完成", imageName: "first_guide"),
        GuideModel(title: "零流量", desc: "海量资料随时传", imageName: "second_guide"),
        GuideModel(title: "不限平台", desc: "安卓、ios跨平台传输", imageName: "third_guide"),
    ]
    
    override func shouldHideHeaderView() -> Bool {
        return true
    }

    override func shouldDisableSwipeGesture() -> Bool {
        return true
    }
    
    private lazy var guideView: BannerView = {
        let view = BannerView()
        view.dataSource = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews()
        setupActions()
    }
    
    private func setupSubViews() {
        view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(146)
            make.height.equalTo(520)
        }
        
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-87)
            make.height.equalTo(46)
            make.width.equalTo(274)
        }
    }
    
    func setupActions() {
        bottomBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] in
            guard let self = self else { return }
            if self.currentIndex + 1 < self.guideArray.count {
                self.guideView.flipNext()
                self.currentIndex += 1
            } else {
                self.dismissAction?()
            }
        }.disposed(by: bag)
    }
}

extension WelcomeViewController: BannerViewDataSource {
    func dataOfBanners(_ bannerView: BannerView) -> [GuideModel] {
        return guideArray
    }
}
