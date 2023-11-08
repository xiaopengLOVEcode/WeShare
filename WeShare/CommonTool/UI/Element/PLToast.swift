

import Foundation

final class PLToast: NSObject {
    static func showAutoHideHint(_ hint: String) {
        showAutoHideHint(hint, in: UIApplication.shared.keyWindow)
    }

    static func showAutoHideHint(_ hint: String, in view: UIView) {
        showAutoHideHint(hint, in: view, hideAfterDelay: 1)
    }

    static func showAutoHideHint(_ hint: String, in view: UIView? = nil, hideAfterDelay: TimeInterval = 1) {
        guard let view = view else { return }
        if let hud = PLTextHUDView.hudView(in: view) as? PLTextHUDView, hud.text == hint {
        } else {
            HUDView.hideAllHUDViews(in: view)
            let hud = PLTextHUDView.createHUDView(in: view)
            hud?.setText(hint)
            hud?.hide(animated: true, delay: hideAfterDelay)
        }
    }
}
