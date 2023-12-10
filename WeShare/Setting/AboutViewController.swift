//
//  AboutViewController.swift
//  WeShare
//
//  Created by XP on 2023/12/5.
//

import Foundation
import UIKit

final class AboutViewController: PLBaseViewController {
    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "BigIcon")
    }
    
    let tipLabel = UILabel().then {
        $0.text = "换机助手1.0"
        $0.font = .font(16)
        $0.textColor = .pl_title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    private func setupSubViews() {
        title = "关于我们"
        headerView.leftButton.isHidden = false
        contentView.addSubview(imageView)
        contentView.addSubview(tipLabel)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
    }
    
}
