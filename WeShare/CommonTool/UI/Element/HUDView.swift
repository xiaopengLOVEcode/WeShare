//
//  HUDView.swift
//  Aries
//
//  Created by baochuquan on 2022/11/29.
//

import Foundation
import UIKit
import SnapKit

open class HUDView: UIView {
    private var timer: Timer?
    private var showDelay: TimeInterval = 0
    private var hideDelay: TimeInterval = 0
    private var showAnimated: Bool = true
    private var hideAnimated: Bool = true
    public let contentView = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setupContentView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    public func show(animated: Bool, delay: TimeInterval) {
        self.showAnimated = animated
        self.showDelay = delay
        if showDelay > 0 {
            alpha = 0
            setupTimer(for: true)
        } else {
            show()
        }
    }

    public func hide(animated: Bool, delay: TimeInterval) {
        self.hideAnimated = animated
        self.hideDelay = delay
        if hideDelay > 0 {
            setupTimer(for: false)
        } else {
            hide()
        }
    }
}

public extension HUDView {
    static func hudViews(in view: UIView) -> [HUDView] {
        var hudViews = [HUDView]()
        for subview in view.subviews {
            if let hud = subview as? HUDView {
                hudViews.append(hud)
            }
        }
        return hudViews
    }

    static func hudView(in view: UIView) -> HUDView? {
        for subview in view.subviews.reversed() {
            if let hud = subview as? HUDView {
                return hud
            }
        }
        return nil
    }

    static func hideAllHUDViews(in view: UIView) {
        let huds = HUDView.hudViews(in: view)
        for hud in huds {
            hud.hide()
        }
    }
}

private extension HUDView {
    func setupTimer(for show: Bool) {
        resetTimer()
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: show ? showDelay : hideDelay,
            repeats: false,
            block: { [weak self] (_) in
                guard let self = self else { return }
                if show {
                    self.show()
                } else {
                    self.hide()
                }
            }
        )
        RunLoop.main.add(timer!, forMode: .common)
    }

    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }

    func show() {
        if showAnimated {
            alpha = 0.0
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1.0
            }
        } else {
            alpha = 1.0
        }
    }

    func hide() {
        resetTimer()
        if hideAnimated {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0.0
            } completion: { _ in
                self.removeFromSuperview()
            }
        } else {
            alpha = 0.0
            removeFromSuperview()
        }
    }
}
