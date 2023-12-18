//
//  UIViewController+ChildVC.swift


import Foundation
import UIKit

public extension UIViewController {
    func ars_addChildVC(_ childVC: UIViewController) {
        addChild(childVC)
        view.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
    
    func ars_removeChildVC(_ childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
}
