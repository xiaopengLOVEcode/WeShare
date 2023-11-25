//
//  CalendarCell.swift
//  WeShare
//
//  Created by XP on 2023/11/22.
//

import Foundation
import RxSwift

final class CalendarCell: UITableViewCell {
    
    var isBtnSelected = false {
        didSet {
            checkBtn.isSelected = isBtnSelected
        }
    }
    
    private let titleLable = UILabel().then {
        $0.font = .boldFont(16)
        $0.textColor = .pl_main
    }
    
    private let subTitleLable = UILabel().then {
        $0.font = .boldFont(16)
        $0.textColor = UIColor(hex: 0x85878D)
    }
    
    private let bag = DisposeBag()
    
    private lazy var checkBtn: UIButton = {
        let checkBtn = UIButton(type: .custom)
        checkBtn.rx.tap.subscribeNext { [weak checkBtn, weak self]_ in
            guard let checkBtn = checkBtn, let self = self else { return }
            // 点击复选框按钮
            checkBtn.isSelected.toggle()
            self.isBtnSelected = checkBtn.isSelected
        }.disposed(by: bag)
        checkBtn.setImage(UIImage(named: "unselected"), for: .normal)
        checkBtn.setImage(UIImage(named: "selected"), for: .selected)
        return checkBtn
    }()
    
    private let grayLine = UIView().then {
        $0.backgroundColor = UIColor(hex: 0x000E1F, alpha: 0.12)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(checkBtn.snp.right).offset(25)
        }
        
        contentView.addSubview(subTitleLable)
        subTitleLable.snp.makeConstraints { make in
            make.left.equalTo(titleLable)
            make.top.equalTo(titleLable.snp.bottom).offset(8)
        }
    }
}
