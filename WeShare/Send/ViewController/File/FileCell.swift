//
//  FileCell.swift
//  WeShare
//
//  Created by XP on 2023/11/22.
//

import Foundation
import RxSwift

protocol FileCellProtocol: AnyObject {
    func fileCellBtnClick()
}

final class FileCell: UITableViewCell {
    
    var didSelectItemBlock: ((Bool) -> Void)? = nil
    
    static let identifier = "FileCellIdentifier"
    
    weak var delegate: FileCellProtocol?
    
    var isBtnSelected = false {
        didSet {
            checkBtn.isSelected = isBtnSelected
        }
    }
    
    private let titleLable = UILabel().then {
        $0.font = .boldFont(17)
        $0.textColor = .pl_title
        $0.numberOfLines = 2
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
            self.delegate?.fileCellBtnClick()
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
            make.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(subTitleLable)
        subTitleLable.snp.makeConstraints { make in
            make.left.equalTo(titleLable)
            make.top.equalTo(titleLable.snp.bottom).offset(8)
        }
        
        contentView.addSubview(grayLine)
        grayLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(titleLable)
            make.right.equalToSuperview().offset(-24)
        }
    }
    
    func bindData(with fileName: FileResourceModel) {
        titleLable.text = fileName.filePath.lastPathComponent
        checkBtn.isSelected = fileName.isSelected
    }
}
