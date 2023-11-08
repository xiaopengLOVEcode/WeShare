//
//  OrderMenuCell.swift
//  PowerLoans
//
//  Created by Neo on 2023/9/4.
//

import Foundation
import PagingKit

final class OrderMenuCell: PagingMenuViewCell {
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.shadowColor = UIColor(hex: 0x000000, alpha: 0.06).cgColor
        $0.layer.shadowOffset = CGSizeMake(0, 4)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 5
    }

    private var curImageStr = ""

    private let gradientLayer = WSGradientView().then {
        $0.setColors([UIColor(hex: 0x00CF87), UIColor(hex: 0x00F0AD)])
        $0.setStart(CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5))
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.isHidden = true
    }

    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
    }

    let imageView = UIImageView()

    let titleLabel = UILabel().then {
        $0.font = .font(14)
        $0.textColor = .pl_title
    }

    override public var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = UIColor.white
                imageView.image = UIImage(named: curImageStr + "_selected")
                gradientLayer.isHidden = false
            } else {
                titleLabel.textColor = .pl_title
                imageView.image = UIImage(named: curImageStr)
                gradientLayer.isHidden = true
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCurrrentImageStr(_ imageStr: String) {
        curImageStr = imageStr
    }

    private func setupSubviews() {
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.equalTo(78)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }

        contentView.addSubview(gradientLayer)
        gradientLayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        [imageView, titleLabel].forEach { item in
            hStackView.addArrangedSubview(item)
        }

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }
}
