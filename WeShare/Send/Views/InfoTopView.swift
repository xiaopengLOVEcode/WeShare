//
//  SendingTopView.swift
//  WeShare
//
//  Created by XP on 2023/11/7.
//

import UIKit
import SnapKit
import Then

enum PageStyle {
    case send
    case receive
    
    var title: String {
        switch self {
        case .send:
            return "已发送"
        case .receive:
            return "已接收"
        }
    }
    
    var vcTitle:String {
        switch self {
        case .send:
            return "发送中"
        case .receive:
            return "接受中"
        }
    }
    
    var bottomText: String {
        switch self {
        case .send:
            return "取消发送"
        case .receive:
            return "取消接受"
        }
    }
}

final class InfoTopView: UIView {
    
    private let leftVStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 7
        $0.alignment = .center
    }
    
    private let rightVStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 7
        $0.alignment = .center
    }
    
    private let hasSendLabel = UILabel().then {
        $0.font = .font(12)
        $0.textColor = UIColor(hex: 0x1D222C)
    }
    
    private let residueLabel = UILabel().then {
        $0.font = .font(12)
        $0.textColor = UIColor(hex: 0x1D222C)
    }
    
    private let timeHstackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .bottom
    }
    
    private let timeLabel = UILabel().then {
        $0.textColor = .pl_main
        $0.font = .boldFont(32)
    }
    
    private let timeUnitLabel = UILabel().then {
        $0.textColor = .pl_main
        $0.font = .font(15)
        $0.text = "分钟"
    }
    
    private let sizeHstackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .bottom
    }
    
    private let sendSizeLabel = UILabel().then {
        $0.textColor = UIColor(hex: 0xFF8A32)
        $0.font = .boldFont(32)
    }
    
    private let sizeUnitLabel = UILabel().then {
        $0.textColor = UIColor(hex: 0xFF8A32)
        $0.font = .font(15)
        $0.text = "GB"
    }
    
    private let pageStyle: PageStyle
    
    init(style: PageStyle) {
        self.pageStyle = style
        super.init(frame: .zero)
        setupSubViews()
        addHandleEvent()
    }
    
    private func setupSubViews() {
        addSubview(leftVStackView)
        leftVStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.centerY.equalToSuperview()
        }
        [hasSendLabel, sizeHstackView].forEach { itemView in
            leftVStackView.addArrangedSubview(itemView)
        }
        
        [timeLabel, timeUnitLabel].forEach { item in
            timeHstackView.addArrangedSubview(item)
        }
        
        hasSendLabel.text = pageStyle.title
        addSubview(rightVStackView)
        rightVStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
        }
        
        [residueLabel, timeHstackView].forEach { itemView in
            rightVStackView.addArrangedSubview(itemView)
        }
        
        [sendSizeLabel, sizeUnitLabel].forEach { item in
            sizeHstackView.addArrangedSubview(item)
        }
        residueLabel.text = "剩余时间"
    }
    
    func update(with size: Double, time: String) {
        timeLabel.text = ""
        sendSizeLabel.text = ""
    }
    
    private func addHandleEvent() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
