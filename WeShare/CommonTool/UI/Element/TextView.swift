

import UIKit

public final class TextView: UITextView {

    public let placeholderLabel = UILabel()

    public init(placeholderText: String = "", placeholderColor: UIColor = UIColor(hex: 0x8B8B8B)) {
        super.init(frame: .zero, textContainer: nil)

        setupSubviews()
        setupActions()

        setPlaceholder(text: placeholderText, color: placeholderColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setPlaceholder(text: String? = nil, color: UIColor? = nil) {
        if let text = text {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = 6
            placeholderLabel.attributedText = .init(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paraStyle])
        }

        if let color = color {
            placeholderLabel.textColor = color
        }
    }

    public override var text: String! {
        get { super.text }
        set {
            super.text = newValue
            self.placeholderLabel.isHidden = !newValue.isEmpty
        }
    }

    public override var font: UIFont? {
        get { super.font }
        set {
            super.font = newValue
            self.placeholderLabel.font = newValue
        }
    }
}

extension TextView {
    func setupSubviews() {

        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { (make) in
            make.top.leading.equalTo(16)
            make.width.lessThanOrEqualTo(self).offset(-32)
        }
    }

    func setupActions() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveTextDidChange(_:)),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func didReceiveTextDidChange(_ notification: Notification) {
        self.placeholderLabel.isHidden = !self.text.isEmpty
    }
}
