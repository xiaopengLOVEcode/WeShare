//
//  IntroduceCenterView.swift
//  WeShare
//
//  Created by xialipeng on 2023/11/10.
//

import Foundation
import UIKit
import SnapKit

final class IntroduceCenterView: UIView {
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.layer.shadowOffset = CGSizeMake(0, 6)
        $0.layer.shadowRadius = 16
        $0.layer.shadowOpacity = 1
        $0.layer.shadowColor = UIColor(hex: 0x000000, alpha: 0.05).cgColor
    }
    
    private let avatarImageView = UIImageView().then {
        $0.image = UIImage(named: "")
        $0.layer.cornerRadius = 25
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "李木子"
        $0.font = .font(18)
        $0.textColor = UIColor(hex: 0x000000, alpha: 0.87)
    }
    
    private let descLabel = UILabel().then {
        $0.text = "这个换机助手太好用啦，一键完成手机资料同步。"
        $0.font = .font(14)
        $0.numberOfLines = 2
        $0.textColor = UIColor(hex: 0x000000, alpha: 0.87)
    }
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            make.width.height.equalTo(50)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalTo(avatarImageView.snp.right).offset(9)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-11)
            make.right.equalToSuperview().offset(-14)
        }
    }
}
