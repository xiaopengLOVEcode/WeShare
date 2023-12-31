//
//  PhotoSelectedCell.swift
//  WeShare
//
//  Created by XP on 2023/11/11.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import TZImagePickerController

protocol PhotoSelectedHeaderDelegate: AnyObject {
    func didSelectCommentActionCell(section: Int)
    func didSelectAllCommentActionCell(section: Int)
}

final class PhotoSelectedHeader: UICollectionViewCell {
    weak var delegate: PhotoSelectedHeaderDelegate?

    var section: Int = -1

    private var isExpand = false

    private let bag = DisposeBag()

    static let reuseIdentifier = "PhotoSelectedCellReuseIdentifier"

    private let titleLabel = UILabel().then {
        $0.textColor = .pl_title
        $0.font = .font(14)
    }

    private let arrowImg = UIImageView()

    private let rightBtn = UIButton().then {
        $0.setTitle("全选", for: .normal)
        $0.setTitle("全选", for: .highlighted)
        $0.titleLabel?.font = .font(14)
        $0.isHidden = true
        $0.setTitleColor(UIColor.pl_main, for: .normal)
        $0.setTitleColor(UIColor.pl_main, for: .highlighted)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        addHandleEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }

        contentView.addSubview(arrowImg)
        arrowImg.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(1)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    func update(model: PhotoItemGroupModel) {
        titleLabel.text = model.bumModel.name
        let imgStr = model.isExpand ? "up_arrow" : "down_arrow"
        arrowImg.image = UIImage(named: imgStr)
        rightBtn.isHidden = !model.isExpand
        let rightTitle = model.isSelectedAll ? "取消全选" : "全选"
        rightBtn.setTitle(rightTitle, for: .normal)
        rightBtn.setTitle(rightTitle, for: .highlighted)
    }

    private func addHandleEvent() {
        contentView.rx.tapGesture().when(.recognized).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didSelectCommentActionCell(section: self.section)
            self.isExpand.toggle()
            self.rightBtn.isHidden = !self.isExpand
            let imgStr = self.isExpand ? "up_arrow" : "down_arrow"
            self.arrowImg.image = UIImage(named: imgStr)
        }.disposed(by: bag)

        rightBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didSelectAllCommentActionCell(section: self.section)
        }.disposed(by: bag)
    }
}
