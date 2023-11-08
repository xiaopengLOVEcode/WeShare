

import Foundation
import SnapKit
import UIKit

open class PLPresentModalController: NSObject {
    class Content {
        weak var view: PLPopupBaseView?
        weak var mask: UIView?

        init(view: PLPopupBaseView?) {
            self.view = view
            mask = view?.maskLayer
        }
    }

    static let shared = PLPresentModalController()
    private var contents = [Content]()
}

public extension PLPresentModalController {
    @discardableResult
    class func show(animated: Bool, view: PLPopupBaseView) -> Bool {
        PLPresentModalController.shared.show(animated: animated, view: view, completion: {})
    }

    @discardableResult
    class func show(animated: Bool, view: PLPopupBaseView, completion: @escaping () -> Void) -> Bool {
        PLPresentModalController.shared.show(animated: animated, view: view, completion: completion)
    }

    @discardableResult
    class func hide(animated: Bool, completion: @escaping () -> Void) -> Bool {
        PLPresentModalController.shared.hide(animated: animated, completion: completion)
    }

    @discardableResult
    class func hide(animated: Bool) -> Bool {
        PLPresentModalController.shared.hide(animated: animated, completion: {})
    }
}

private extension PLPresentModalController {
    @discardableResult
    func show(animated: Bool, view: PLPopupBaseView, completion: @escaping () -> Void) -> Bool {
        guard let window = UIWindow.keyWindow else { return false }

        let content = Content(view: view)
        contents.append(content)

        view.maskLayer.removeFromSuperview()
        window.addSubview(view.maskLayer)
        window.addSubview(view)

        view.maskLayer.alpha = 0
        view.maskLayer.snp.remakeConstraints { make in
            make.edges.equalTo(window)
        }

        let size = UIScreen.main.bounds.size
        view.snp.remakeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalToSuperview()
            make.bottom.equalTo(size.height)
        }
        window.layoutIfNeeded()

        transitionIn(content: content, animated: animated, completion: completion)
        return true
    }

    @discardableResult
    func hide(animated: Bool, completion: @escaping () -> Void) -> Bool {
        guard !contents.isEmpty else {
            completion()
            return false
        }
        let content = contents.removeLast()
        transitionOut(content: content, animated: animated) {
            self.cleanup(content)
            completion()
        }
        return true
    }
}

private extension PLPresentModalController {
    func cleanup(_ content: Content) {
        content.view?.removeFromSuperview()
        content.mask?.removeFromSuperview()
    }

    func transitionIn(content: Content, animated: Bool, completion: @escaping () -> Void) {
        guard let contentView = content.view, let window = UIApplication.shared.keyWindow else {
            completion()
            return
        }
        contentView.snp.remakeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalToSuperview()
            make.bottom.equalTo(0)
        }

        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                contentView.maskLayer.alpha = 1
                window.layoutIfNeeded()
            }, completion: { _ in
                completion()
            })
        } else {
            contentView.maskLayer.alpha = 1
            window.layoutIfNeeded()
            completion()
        }
    }

    func transitionOut(content: Content, animated: Bool, completion: @escaping () -> Void) {
        guard let contentView = content.view, let window = UIApplication.shared.keyWindow else {
            completion()
            return
        }
        let size = UIScreen.main.bounds.size
        contentView.snp.remakeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalToSuperview()
            make.bottom.equalTo(size.height)
        }

        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                contentView.maskLayer.alpha = 0
                window.layoutIfNeeded()
            }, completion: { _ in
                completion()
            })
        } else {
            contentView.maskLayer.alpha = 0
            window.layoutIfNeeded()
            completion()
        }
    }
}
