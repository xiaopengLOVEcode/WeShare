
import UIKit
import Then

open class PLPopupBaseView: UIView {
    public let maskLayer = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.54)
    }
    private let guestureLayer = UIView().then {
        $0.backgroundColor = UIColor.clear
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(maskLayer)
        addSubview(guestureLayer)
        maskLayer.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        guestureLayer.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        setupTapGesture()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(guestureLayerDidClick))
        guestureLayer.addGestureRecognizer(tapGesture)
    }

    @objc
    open func guestureLayerDidClick() {
        // 蒙层点击逻辑
    }
}
