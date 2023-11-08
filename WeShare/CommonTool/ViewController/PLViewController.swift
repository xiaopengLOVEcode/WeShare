

import UIKit
import SnapKit

@objcMembers
open class PLViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public let headerView = PLHeaderView()
    public let contentView = UIView()
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "pl_backImg")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundImageView.isHidden = shouldHiddenBackView()
        setupNavigationStyle()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if shouldDisableAutoLockScreen() {
            disableAutoLockScreen(true)
        }
        let count = self.navigationController?.viewControllers.count ?? 0
        if count >= 2 {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if shouldDisableAutoLockScreen() {
            disableAutoLockScreen(false)
        }
    }
    
    open func shouldHideHeaderView() -> Bool {
        return false
    }
    
    open func shouldHiddenBackView() -> Bool {
        return false
    }
        
    @objc open func headerViewReturnButtonPressed(_ sender: Any?) {
        if PLViewControllerUtils.isPresentedViewController(self) {
            presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    open func shouldDisableAutoLockScreen() -> Bool {
        return false
    }
    
    open func disableAutoLockScreen(_ disable: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        if disable {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    open func shouldDisableSwipeGesture() -> Bool {
        return false
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        var result = true
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            result = result && !(self.navigationController?.transitionCoordinator?.isAnimated ?? false)
            result = result && (self.navigationController?.viewControllers.count ?? 0) >= 2
            result = result && !shouldDisableSwipeGesture()
        }
        return result
    }
    
    public override var title: String? {
        didSet {
            super.title = title
            headerView.setTitle(title ?? "")
        }
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

extension PLViewController {
    func setupNavigationStyle() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        let item = UIBarButtonItem()
        item.title = ""
        navigationItem.backBarButtonItem = item
        
        contentView.backgroundColor = .clear
        view.addSubview(contentView)
        
        let showHeaderView = !shouldHideHeaderView()
        
        if showHeaderView {
            view.addSubview(headerView)
            headerView.snp.makeConstraints { make in
                make.height.equalTo(PLHeaderView.headerViewHeight())
                make.top.leading.trailing.equalToSuperview()
            }
            headerView.setTitle(title ?? "")
            headerView.setLeftReturnButton(with: self, action: #selector(headerViewReturnButtonPressed(_:)))
        }
        
        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        contentView.snp.makeConstraints { make in
            if showHeaderView {
                make.top.equalTo(headerView.snp.bottom)
            } else {
                make.top.equalTo(view)
            }
            make.leading.bottom.trailing.equalTo(view)
        }
        view.layoutIfNeeded()
    }
}
