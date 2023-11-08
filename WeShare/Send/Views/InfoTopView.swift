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
    
    private let timeLabel = UILabel()
    
    private let sendSizeLabel = UILabel()
    
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
        [hasSendLabel, sendSizeLabel].forEach { itemView in
            leftVStackView.addArrangedSubview(itemView)
        }
        
        hasSendLabel.text = pageStyle.title
        addSubview(rightVStackView)
        rightVStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
        }
        [residueLabel, timeLabel].forEach { itemView in
            rightVStackView.addArrangedSubview(itemView)
        }
        residueLabel.text = "剩余时间"
    }
    
    private func addHandleEvent() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
