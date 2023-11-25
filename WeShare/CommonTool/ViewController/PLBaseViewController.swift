

import Foundation
import Then
import UIKit
import RxSwift

class PLBaseViewController: PLViewController {
    private var errorAction: (() -> Void)?

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
        self.hidesBottomBarWhenPushed = true
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let bag = DisposeBag()

    public var disableSwipeGuesture = false

    open override func shouldDisableSwipeGesture() -> Bool {
        return disableSwipeGuesture
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        if
            let normalImage = UIImage(named: "return"),
            let highlightedImage = UIImage(named: "return")
        {
            headerView.setLeftImageButton(
                with: normalImage,
                highlightedImage: highlightedImage,
                target: self,
                action: #selector(headerViewReturnButtonPressed)
            )
            headerView.leftButton.isHidden = true
        }
        view.backgroundColor = .white
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    open func layoutContentViewFullScreen() {
        contentView.removeFromSuperview()
        view.addSubview(contentView)
        if headerView.superview == nil {
            view.addSubview(headerView)
        }
        view.bringSubviewToFront(headerView)
        contentView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    open func layoutContentViewBelowHeaderView() {
        contentView.snp.removeConstraints()
        contentView.removeFromSuperview()
        view.addSubview(contentView)
        if headerView.superview == nil {
            view.addSubview(headerView)
        }
        view.bringSubviewToFront(headerView)
        contentView.snp.remakeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.bottom.right.equalTo(view)
        }
    }

    open func hideHeaderView(_ hidden: Bool) {
        guard headerView.isHidden != hidden else { return }
        if hidden {
            headerView.isHidden = true
            layoutContentViewFullScreen()
        } else {
            headerView.isHidden = false
            layoutContentViewBelowHeaderView()
        }
    }

    open func removeFromNavigationStack() {
        if var vcs = navigationController?.viewControllers {
            vcs.removeAll(where: { $0 == self })
            navigationController?.viewControllers = vcs
        }
    }
}
