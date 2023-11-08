
import Foundation
import UIKit
import Then
import SnapKit

class PLCommonSelectAlertView: PLPopupBaseView {
    public struct Action {
        public let title: String
        public var action: () -> Void
        
        init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }
    
    private let imageView = UIImageView()
    
    private let closeBtn = UIButton().then {
        $0.setImage(UIImage(named: "close_btn"), for: .normal)
        $0.setImage(UIImage(named: "close_btn"), for: .highlighted)
    }
    
    public var maskAction: (() -> Void)?
    private let gestureView = UIView()
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 18
    }
    
    public let titleLabel = UILabel().then {
        $0.textColor = UIColor.pl_title
        $0.font = UIFont(name: "Century Gothic-Bold", size: 12)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private let title: String
    private let action: Action
    private let contentWidth: CGFloat

    public init(title: String, action: Action, width: CGFloat = 290, maskAction: (() -> Void)? = nil) {
        self.action = action
        self.title = title
        self.contentWidth = width
        self.maskAction = maskAction
        super.init(frame: .zero)
        setupSubviews()
        addHandleEvent()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(gestureView)
        addSubview(contentView)
        titleLabel.text = title
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.right.equalToSuperview().offset(-11)
            make.top.equalToSuperview().offset(70)
            make.bottom.equalToSuperview().offset(-70)
        }

        let bottomBtn = UIButton().then {
            $0.setTitle(action.title, for: .normal)
            $0.layer.cornerRadius = 6
            $0.layer.masksToBounds = true
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .boldFont(12)
            $0.backgroundColor = UIColor(hex: 0x100C12)
        }
        contentView.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(55)
            make.right.equalToSuperview().offset(-55)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(32)
        }
        bottomBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)

        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(contentWidth)
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(38)
            make.right.equalToSuperview().offset(19)
            make.top.equalToSuperview().offset(-19)
        }
        
        gestureView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func addHandleEvent() {
        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        gestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureViewClick)))
    }
    
    @objc private func gestureViewClick() {
        self.maskAction?()
    }
    
    @objc private func btnClick(sender: UIButton) {
        let actionBlock = action
        actionBlock.action()
    }

    @discardableResult
    public func show(_ completion: (() -> Void)? = nil) -> Bool {
        PLFadedModalController.show(
            animated: true,
            view: self,
            completion: {
                completion?()
            }
        )
    }
    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//
//    }

    @discardableResult
    @objc public func hide() -> Bool {
        PLFadedModalController.hide(animated: true)
    }
}
