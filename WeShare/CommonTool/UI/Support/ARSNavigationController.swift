

import Foundation
import UIKit

final class ARSNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    private var currentOrientationMask: UIInterfaceOrientationMask = .all

    override public init(rootViewController: UIViewController) {
        self.currentOrientationMask = rootViewController.supportedInterfaceOrientations
        super.init(rootViewController: rootViewController)
        interactivePopGestureRecognizer?.delegate = self
        modalPresentationStyle = .fullScreen
    }
        
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    // MARK: - Rotation
    
    override  var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let supportedMask: UIInterfaceOrientationMask
        if #available(iOS 16.0, *) {
            supportedMask = currentOrientationMask
        } else  {
            supportedMask = topViewController?.supportedInterfaceOrientations ?? .all
        }
        if (supportedMask.rawValue & UIInterfaceOrientationMask.all.rawValue) == 0 {
            return .allButUpsideDown
        }
        return supportedMask
    }
    
    override  var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        let orientation = topViewController?.preferredInterfaceOrientationForPresentation ?? .unknown
        if orientation == .unknown {
            return .portrait
        }
        return orientation
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else { return true }
        let isSwipeGestureDisable = (topViewController as? PLBaseViewController)?.shouldDisableSwipeGesture() ?? false
        var result = true
        result = result && transitionCoordinator == nil || !(transitionCoordinator?.isAnimated ?? false)
        result = result && viewControllers.count >= 2
        result = result && !isSwipeGestureDisable
        return result
    }
}

// MARK: - Maintains currentOrientationMask

extension ARSNavigationController {
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if let orientations = viewControllers.last?.supportedInterfaceOrientations {
            currentOrientationMask = orientations
        }
        super.setViewControllers(viewControllers, animated: animated)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        currentOrientationMask = viewController.supportedInterfaceOrientations
        super.pushViewController(viewController, animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count > 1 {
            currentOrientationMask = viewControllers[viewControllers.count - 2].supportedInterfaceOrientations
        } else if viewControllers.count == 1 {
            currentOrientationMask = viewControllers[0].supportedInterfaceOrientations
        }
        return super.popViewController(animated: animated)
    }

    override  func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if viewControllers.count > 0 {
            currentOrientationMask = viewControllers[0].supportedInterfaceOrientations
        }
        return super.popToRootViewController(animated: animated)
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        currentOrientationMask = viewController.supportedInterfaceOrientations
        return super.popToViewController(viewController, animated: animated)
    }
}
