//
//  ContactCell.swift
//  WeShare
//
//  Created by XP on 2023/11/21.
//

import Foundation
import RxSwift


final class ContactCell: UITableViewCell {
    
    var didSelectItemBlock: ((Bool) -> Void)? = nil
    
    var isBtnSelected = false {
        didSet {
            checkBtn.isSelected = isBtnSelected
        }
    }
    
    private let bag = DisposeBag()
    
    static let identifier = "ContactCellIdentifier"
    
    private let titleLable = UILabel().then {
        $0.textColor = .pl_title
        $0.font = .font(16)
    }
    
    private lazy var checkBtn: UIButton = {
        let checkBtn = UIButton(type: .custom)
        checkBtn.rx.tap.subscribeNext { [weak checkBtn, weak self]_ in
            guard let checkBtn = checkBtn, let self = self else { return }
            // 点击复选框按钮
            checkBtn.isSelected.toggle()
            self.isBtnSelected = checkBtn.isSelected
            self.didSelectItemBlock?(self.isBtnSelected)
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
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(checkBtn.snp.right).offset(25)
        }
        
        contentView.addSubview(grayLine)
        grayLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(titleLable)
            make.right.equalToSuperview().offset(-24)
        }
    }
    
    func bindData(model: PPPersonModel?) {
        guard let person = model else { return }
        titleLable.text = person.name
        checkBtn.isSelected = person.isSelected
    }
}
