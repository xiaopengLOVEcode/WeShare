
import Foundation
import UIKit
import SnapKit

open class PLFadedModalController {
    class Content {
        weak var view: UIView?

        init(view: UIView?) {
            self.view = view
        }
    }

    static let shared = PLFadedModalController()
    private var contents = [Content]()
}

public extension PLFadedModalController {

    @discardableResult
    class func show(animated: Bool, view: UIView) -> Bool {
        PLFadedModalController.shared.show(animated: animated, view: view, completion: {})
    }

    @discardableResult
    class func show(animated: Bool, view: UIView, completion: @escaping () -> Void) -> Bool {
        PLFadedModalController.shared.show(animated: animated, view: view, completion: completion)
    }

    @discardableResult
    class func hide(animated: Bool, completion: @escaping () -> Void) -> Bool {
        PLFadedModalController.shared.hide(animated: animated, completion: completion)
    }

    @discardableResult
    class func hide(animated: Bool) -> Bool {
        PLFadedModalController.shared.hide(animated: animated, completion: {})
    }
}

private extension PLFadedModalController {
    @discardableResult
    func show(animated: Bool, view: UIView, completion: @escaping () -> Void) -> Bool {
        guard let window = UIWindow.keyWindow else { return false }

        let content = Content(view: view)
        contents.append(content)

        window.addSubview(view)
        view.alpha = 0
        view.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        view.layoutIfNeeded()

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
        transitionOut(content: content, animated: animated) { [weak self] in
            self?.cleanup(content)
            completion()
        }
        return true
    }
}

private extension PLFadedModalController {
    func cleanup(_ content: Content) {
        content.view?.removeFromSuperview()
    }

    func transitionIn(content: Content, animated: Bool, completion: @escaping () -> Void) {
        guard let contentView = content.view else {
            completion()
            return
        }
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                contentView.alpha = 1
            }, completion: { (finished) in
                completion()
            })
        } else {
            contentView.alpha = 1
            contentView.layoutIfNeeded()
            completion()
        }
    }

    func transitionOut(content: Content, animated: Bool, completion: @escaping () -> Void) {
        guard let contentView = content.view else {
            completion()
            return
        }
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                contentView.alpha = 0
                contentView.layoutIfNeeded()
            }, completion: { (finished) in
                completion()
            })
        } else {
            contentView.alpha = 0
            contentView.layoutIfNeeded()
            completion()
        }
    }
}
