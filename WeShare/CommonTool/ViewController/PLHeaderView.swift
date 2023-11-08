
import Foundation
import SnapKit

@objc(PLHeaderView)
public class PLHeaderView: UIView {
    @objc public let backgroundView = UIView()
    @objc public let contentView = UIView()
    @objc public let titleLabel = UILabel()
    @objc public private(set) var leftButton = UIButton()
    @objc public private(set) var rightButton = UIButton()

    private static let navigationBarHeight: CGFloat = 44.0
    private static let statusBarHeight: CGFloat = 20.0

    private let buttonContentMargin: CGFloat = 16.0
    private let leftButtonMinWidth: CGFloat = 60.0
    private let redpointWidth: CGFloat = 7.0
    private let redpointTopPadding: CGFloat = 10.5
    private let redpointRightPadding: CGFloat = 6.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc static public func headerViewHeight() -> CGFloat {
        return applicationTopBarHeight()
    }
}

// MARK: - Title
public extension PLHeaderView {
    @objc(setTitle:)
    func setTitle(_ title: String) {
        if titleLabel.superview == nil {
            setupTitleLabel()
        }
        titleLabel.alpha = 1.0
        titleLabel.text = title
    }

    @objc(setTransitionFromOldTitle:newTitle:progress:threshold:)
    func setTransitionFrom(oldTitle: String, newTitle: String, progress: CGFloat, threshold: CGFloat) {
        let correctProgress: CGFloat = min(max(progress, 0.0), 1.0)
        if titleLabel.superview == nil {
            setupTitleLabel()
        }
        if correctProgress < threshold {
            titleLabel.text = oldTitle
            if threshold > 0 {
                titleLabel.alpha = 1.0 - correctProgress / threshold
            }
        } else {
            titleLabel.text = newTitle
            if 1.0 - threshold > 0 {
                titleLabel.alpha = (correctProgress - threshold) / (1.0 - threshold)
            }
        }
    }
}

// MARK: - LeftButton & RightButton
public extension PLHeaderView {

    @objc(setLeftImageButtonWithImage:highlightedImage:target:action:)
    func setLeftImageButton(with image: UIImage,
                            highlightedImage: UIImage,
                            target: Any,
                            action: Selector) {
        setImageButton(with: image,
                       highlightedImage: highlightedImage,
                       target: target,
                       action: action,
                       isLeftButton: true)
    }

    @objc(setRightImageButtonWithImage:highlightedImage:target:action:)
    func setRightImageButton(with image: UIImage,
                             highlightedImage: UIImage,
                             target: Any,
                             action: Selector?) {
        setImageButton(with: image,
                       highlightedImage: highlightedImage,
                       target: target,
                       action: action,
                       isLeftButton: false)
    }

    @objc(setButonTransitionWithTarget:oldTitle:oldImage:oldHighlightedImage:oldAction:newTitle:newImage:newHighlightedImage:newAction:progress:threshold:isLeftButton:)
    func setButonTransition(with target: Any,
                            oldTitle: String?,
                            oldImage: UIImage?,
                            oldHighlightedImage: UIImage?,
                            oldAction: Selector,
                            newTitle: String?,
                            newImage: UIImage?,
                            newHighlightedImage: UIImage?,
                            newAction: Selector,
                            progress: CGFloat,
                            threshold: CGFloat,
                            isLeftButton: Bool) {
        assert(oldTitle != nil || oldImage != nil, "old title and image can not both be nil")
        assert(newTitle != nil || newImage != nil, "new title and image can not both be nil")
        assert(threshold > 0 && threshold < 1, "invalid threshold")
        let correctProgress: CGFloat = min(max(progress, 0.0), 1.0)
        let alpha: CGFloat
        let button: UIButton
        let width: CGFloat
        if correctProgress < threshold {
            alpha = 1.0 - correctProgress / threshold
            if let image = oldImage,
               let highlightImage = oldHighlightedImage {
                button = createImageButton(with: image, highlightedImage: highlightImage, target: target, action: oldAction)
                width = image.size.width
            } else {
                button = createTextButton(with: oldTitle ?? "", target: target, action: oldAction)
                let arritbutedTitle = NSAttributedString(string: oldTitle ?? "", attributes: [NSAttributedString.Key.font: button.titleLabel?.font ?? UIFont.systemFont(ofSize: 16.0)])
                width = ceil(arritbutedTitle.size().width)
            }
        } else {
            alpha = (correctProgress - threshold) / (1.0 - threshold)
            if let image = newImage,
               let highlightedImage = newHighlightedImage {
                button = createImageButton(with: image, highlightedImage: highlightedImage, target: target, action: newAction)
                width = image.size.width
            } else {
                button = createTextButton(with: newTitle ?? "", target: target, action: newAction)
                let arritbutedTitle = NSAttributedString(string: newTitle ?? "", attributes: [NSAttributedString.Key.font: button.titleLabel?.font ?? UIFont.systemFont(ofSize: 16.0)])
                width = ceil(arritbutedTitle.size().width)
            }
        }
        button.alpha = alpha
        updateInsets(for: button, with: width, isLeftButton: isLeftButton)
        updateHeader(with: button, isLeftButton: isLeftButton)
    }

    @objc(setLeftButtonWithText:target:action:)
    func setLeftButton(with text: String, target: Any, action: Selector?) {
        setTextButton(with: text, target: target, action: action, isLeftButton: true)
    }

    @objc(setRightButtonWithText:target:action:)
    func setRightButton(with text: String, target: Any?, action: Selector?) {
        setTextButton(with: text, target: target, action: action, isLeftButton: false)
    }

    @objc(setLeftReturnButtonWithTarget:action:)
    func setLeftReturnButton(with target: Any, action: Selector?) {
        guard let normalImage = UIImage(named: "NavigationReturnButtonDefault"),
              let highlightedImage = UIImage(named: "NavigationReturnButtonPressedDefault") else {
            return
        }
        setImageButton(with: normalImage, highlightedImage: highlightedImage, target: target, action: action, isLeftButton: true)
    }

    @objc func removeLeftButton() {
        leftButton.removeFromSuperview()
    }

    @objc func removeRightButton() {
        rightButton.removeFromSuperview()
    }
}

public extension PLHeaderView {
    @objc func updateHeaderButton(_ button: UIButton, isLeft: Bool) {
        updateInsets(for: button, with: button.frame.size.width, isLeftButton: false)
        updateHeader(with: button, isLeftButton: false)
    }
}

// MARK: - Setup
private extension PLHeaderView {
    func setupSubviews() {
        backgroundView.backgroundColor = .clear
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Self.defaultStatusBarHeight())
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func setupTitleLabel() {
        titleLabel.font = UIFont.boldFont(18)
        titleLabel.textColor = .pl_title
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            // TODO: magic numbers
            make.width.lessThanOrEqualToSuperview().offset(-133)
        }
    }
}

// MARK: - left & right button
private extension PLHeaderView {
    func updateInsets(for button: UIButton,
                      with contentWidth: CGFloat,
                      isLeftButton: Bool) {
        let contentLeftInset: CGFloat = buttonContentMargin
        let contentRightInset: CGFloat
        if isLeftButton {
            contentRightInset = max(leftButtonMinWidth - contentWidth - contentLeftInset, buttonContentMargin)
        } else {
            contentRightInset = buttonContentMargin
        }
        button.frame.size.width = contentLeftInset + contentWidth + contentRightInset
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: contentLeftInset, bottom: 0, right: contentRightInset)
    }

    func updateHeader(with button: UIButton, isLeftButton: Bool) {
        if isLeftButton {
            leftButton.removeFromSuperview()
            leftButton = button
        } else {
            rightButton.removeFromSuperview()
            rightButton = button
        }
        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(button.frame.size.width)
            if isLeftButton {
                make.leading.equalToSuperview()
            } else {
                make.trailing.equalToSuperview()
            }
        }
    }

    func setImageButton(with image: UIImage,
                        highlightedImage: UIImage,
                        target: Any?,
                        action: Selector?,
                        isLeftButton: Bool) {
        let button = createImageButton(with: image, highlightedImage: highlightedImage, target: target, action: action)
        let imageWidth = image.size.width
        updateInsets(for: button, with: imageWidth, isLeftButton: isLeftButton)
        updateHeader(with: button, isLeftButton: isLeftButton)
    }

    func createImageButton(with image: UIImage,
                           highlightedImage: UIImage,
                           target: Any?,
                           action: Selector?) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        if let buttonAction = action {
            button.addTarget(target, action: buttonAction, for: .touchUpInside)
        }
        return button
    }

    func setTextButton(with text: String,
                      target: Any?,
                      action: Selector?,
                      isLeftButton: Bool) {
        let button = createTextButton(with: text, target: target, action: action)
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: button.titleLabel?.font ?? UIFont.systemFont(ofSize: 16.0)])
        let textWidth: CGFloat = ceil(attributedText.size().width)
        updateInsets(for: button, with: textWidth, isLeftButton: isLeftButton)
        updateHeader(with: button, isLeftButton: isLeftButton)
    }

    func createTextButton(with text: String,
                          target: Any?,
                          action: Selector?) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16.0)
        button.setTitleColor(UIColor(hex: 0x272727), for: .normal)
        button.setTitleColor(UIColor(hex: 0x272727, alpha: 0.5), for: .highlighted)
        button.setTitleColor(UIColor(hex: 0x272727, alpha: 0.5), for: .disabled)
        button.setTitle(text, for: .normal)
        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        button.contentVerticalAlignment = .fill
        return button
    }
}

// MARK: - HeaderViewHeight
private extension PLHeaderView {
    static func applicationTopBarHeight() -> CGFloat {
        return navigationBarHeight + defaultStatusBarHeight() + 15
    }

    static func defaultStatusBarHeight() -> CGFloat {
        return statusBarHeight + max(windowSafeAreaInsets().top - statusBarHeight, 0.0)
    }

    static func windowSafeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window {
                return window?.safeAreaInsets ?? .zero
            }
        }
        return .zero
    }
}

// MARK: - SeperatorHeight
private extension PLHeaderView {
    static let sepratorLineHeight: CGFloat = {
        let scale = UIScreen.main.scale
        return scale < 1.5 ? 1.0 : (scale < 2.5 ? 0.5 : 0.3)
    }()
}
