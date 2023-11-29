//
//  FinishView.swift
//  WeShare
//
//  Created by XP on 2023/11/28.
//

import UIKit

final class FinishView: UIView {
    
    private let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 31
        $0.alignment = .center
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "finished")
    }
    
    private let label = UILabel().then {
        $0.text = "发送完成"
        $0.textColor = .pl_main
        $0.font = .font(20)
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        vStackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        vStackView.addArrangedSubview(label)
    }
}
