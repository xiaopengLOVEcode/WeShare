//
//  SwitchBar.swift
//  WeShare
//
//  Created by xialipeng on 2023/11/10.
//

import Foundation

final class SwitchBar: UIView {
    
    var switchCompletion:((Bool) -> Void)? = nil
    
    private let contentView = UIView().then {
        $0.backgroundColor = UIColor(hex: 0xF7F7F8)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let descLabel = UILabel().then {
        $0.text = "开始免费试用"
        $0.font = .boldFont(16)
        $0.textColor = UIColor.pl_title
    }
    
    private let switchControl = ARSUISwitch()
    
    init() {
        super.init(frame: .zero)
        setupSubViews()
        addHandleEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(switchControl)
        switchControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
    }
    
    private func addHandleEvent() {
        switchControl.onCompletion = { [weak self] in
            guard let self = self else { return }
            switchCompletion?(true)
        }
        
        switchControl.offCompletion = { [weak self] in
            guard let self = self else { return }
            switchCompletion?(false)
        }
    }
}
