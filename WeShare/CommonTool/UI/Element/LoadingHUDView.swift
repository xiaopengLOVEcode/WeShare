

import Foundation
import Then

@objcMembers
public final class LoadingHUDView: HUDView {

    public static func createHUDView(in view: UIView?, animated: Bool = true) -> LoadingHUDView? {
        guard let view = view else { return nil }

        let hud = LoadingHUDView(frame: view.frame)
        view.addSubview(hud)
        hud.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hud.superview?.layoutIfNeeded()
        hud.show(animated: animated, delay: 0)
        return hud
    }
}
