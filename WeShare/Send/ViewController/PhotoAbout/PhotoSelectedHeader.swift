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

protocol PhotoSelectedHeaderDelegate: AnyObject {
    func didSelectCommentActionCell(section: Int)
}

final class PhotoSelectedHeader: UICollectionViewCell {
    
    weak var delegate: PhotoSelectedHeaderDelegate?
    
    var section: Int = -1
    
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

    func update(model: PhotoGroupModel) {
        titleLabel.text = model.title
        let imgStr = model.isExpand ? "down_arrow" : "up_arrow"
        arrowImg.image = UIImage(named: imgStr)
        let rightTitle = model.isSelectedAll ? "取消全选" : "全选"
        rightBtn.setTitle(rightTitle, for: .normal)
        rightBtn.setTitle(rightTitle, for: .highlighted)
    }

    private func addHandleEvent() {
        contentView.rx.tapGesture().when(.recognized).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didSelectCommentActionCell(section: self.section)
        }.disposed(by: bag)
    }
}
