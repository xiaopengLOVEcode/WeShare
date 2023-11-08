

import Foundation
import UIKit
import SnapKit
import Then

class PLTextHUDView: HUDView {
    static let padding: CGFloat = 16
    static let maximumWidth: CGFloat = 286

    private let label = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = UIColor.white
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    override func setupContentView() {
        super.setupContentView()
        contentView.backgroundColor = UIColor.black.alpha(0.8)
        contentView.layer.cornerRadius = 10

        contentView.addSubview(label)
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualTo(Self.maximumWidth)
        }

        label.snp.makeConstraints { make in
            make.top.left.equalTo(Self.padding)
            make.bottom.right.equalTo(-Self.padding)
        }
    }

    func setText(_ text: String) {
        label.text = text
    }

    var text: String {
        label.text ?? ""
    }

    static func createHUDView(in view: UIView?, animated: Bool = true, delay: TimeInterval = 0) -> PLTextHUDView? {
        guard let view = view else { return nil }

        let hud = PLTextHUDView(frame: view.frame)
        view.addSubview(hud)
        hud.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hud.superview?.layoutIfNeeded()
        hud.show(animated: animated, delay: delay)
        return hud
    }
}
