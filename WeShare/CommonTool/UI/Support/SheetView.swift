//
//  SheetView.swift
//  Aries
//
//  Created by XP on 2021/4/20.
//

import UIKit
import Then

public final class SheetView: PLPopupBaseView {
    public struct Model {
        public let title: String
        public var selected: Bool
        public let handle: () -> Void

        public init(title: String, selected: Bool, handle: @escaping () -> Void) {
            self.title = title
            self.selected = selected
            self.handle = handle
        }
    }

    private let models: [Model]
    private let cancelBlock: () -> Void

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 7
        $0.backgroundColor = .white
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle("取消", for: .normal)
        $0.titleLabel?.font = UIFont.font(16)
        $0.setTitleColor(.pl_main, for: .normal)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white
    }

    public let contentView = UIView().then {
        $0.backgroundColor = .white
    }

    public init(models: [Model], cancelBlock: @escaping () -> Void = {}) {
        self.models = models
        self.cancelBlock = cancelBlock
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func guestureLayerDidClick() {
        PLPresentModalController.hide(animated: true)
    }
}

private extension SheetView {
    func setupViews() {
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)

        addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.addSubview(stackView)
        stackView.backgroundColor = .clear
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(-LayoutConstants.extraBottomPadding)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        for (index, model) in models.enumerated() {
            let item = UIButton()
            item.backgroundColor = .white
            item.titleLabel?.font = UIFont.font(16)
            item.setTitle(model.title, for: .normal)
            item.setTitleColor(.pl_title, for: .normal)
            item.setTitleColor(.pl_title, for: .selected)
            item.layer.cornerRadius = 15
            stackView.addArrangedSubview(item)
            item.snp.makeConstraints { (make) in
                make.height.equalTo(58)
            }
            item.isSelected = model.selected
            item.tag = index
            item.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
        }
        stackView.addArrangedSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.height.equalTo(58)
        }
    }

    @objc private func itemClick(sender: UIButton) {
        let actionBlock = models[sender.tag]
        actionBlock.handle()
        hide()
    }
    
    @objc private func cancelButtonClick() {
        hide()
        cancelBlock()
    }
}

public extension SheetView {
    @discardableResult
    static func show(models: [Model], cancelBlock: @escaping () -> Void = {}) -> Bool {
        let view = SheetView(models: models, cancelBlock: cancelBlock)
        view.contentView.layer.cornerRadius = 10
        view.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.contentView.layer.masksToBounds = true
        return PLPresentModalController.show(
            animated: true,
            view: view
        )
    }

    @discardableResult
    func hide() -> Bool {
        PLPresentModalController.hide(animated: true)
    }
}
