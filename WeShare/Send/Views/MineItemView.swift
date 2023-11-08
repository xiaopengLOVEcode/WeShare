////
////  MineItemView.swift
////  PowerLoans
////
////  Created by Neo on 2023/9/1.
////
//
//import RxSwift
//import UIKit
//import RxGesture
//
//final class MineItemView: UIView {
//    private let bag = DisposeBag()
//
//    private let itemClickAction: (() -> Void)
//    
//    private let type: SettingType
//
//    private let contentView = UIView()
//
//    private let icon = UIImageView()
//
//    private let itemLabel = UILabel().then {
//        $0.font = .plBoldFont(14)
//    }
//
//    init(type: SettingType, itemClickAction: @escaping (() -> Void)) {
//        self.itemClickAction = itemClickAction
//        self.type = type
//        super.init(frame: .zero)
//        setupSubViews()
//        addHandleEvent()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupSubViews() {
//        addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        contentView.addSubview(icon)
//        icon.snp.makeConstraints { make in
//            make.width.height.equalTo(24)
//            make.left.equalToSuperview()
//        }
//
//        contentView.addSubview(itemLabel)
//        itemLabel.snp.makeConstraints { make in
//            make.left.equalTo(icon.snp.right).offset(14)
//            make.centerY.equalToSuperview()
//        }
//        
//        icon.image = UIImage(named: type.icon)
//        itemLabel.text = type.text
//    }
//
//    private func addHandleEvent() {
//        contentView.rx.tapGesture().when(.recognized).subscribeNext { [weak self] _ in
//            guard let self = self else { return }
//            self.itemClickAction()
//        }.disposed(by: bag)
//    }
//}
