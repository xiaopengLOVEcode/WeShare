//
//  PhotoItemsCell.swift
//  WeShare
//
//  Created by XP on 2023/11/12.
//

import Foundation
import UIKit

final class PhotoItemsCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoItemsCellId"
    
    private let selectedBtn = UIButton().then {
        $0.setImage(UIImage(named: "unselected"), for: .normal)
        $0.setImage(UIImage(named: "unselected"), for: .selected)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    private func setupSubviews() {
        backgroundColor = .red
        
        contentView.addSubview(selectedBtn)
        selectedBtn.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
