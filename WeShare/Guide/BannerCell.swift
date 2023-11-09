//
//  BannerCell.swift
//  WeShare
//
//  Created by XP on 2023/11/9.
//

import Foundation
import SnapKit

final class BannerCell: UICollectionViewCell {
    static let reuseIdentifier = "BannerCellId"
    
    private let imageView = UIImageView()
    
    private let titleLable = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 28)
        $0.textColor = .black
    }
    
    private let descLabel = UILabel().then {
        $0.font = .font(16)
        $0.textColor = UIColor(hex: 0x424242)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(47)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind(with model: GuideModel) {
        imageView.image = UIImage(named: model.imageName)
        titleLable.text = model.title
        descLabel.text = model.desc
    }
}
