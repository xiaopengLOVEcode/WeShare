//
//  SendViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import PagingKit
import UIKit

protocol PageVCProtocol {
    func selectedAll(with all: Bool)
}

extension PageVCProtocol {
    func selectedAll(with all: Bool) {}
}

class SendViewController: PLBaseViewController {
    
    private let photoVc = PhotoViewController()
    private let videoVc = VideoViewController()
    private let contactVc = ContactViewController()
    private let calendarVc = CalendarViewController()
    private let fileVc = FileViewController()
    
    private let menuController = PagingMenuViewController()
    private let contentController = PagingContentViewController()
    private var dataSource: [(menu: String, imageName: String, content: UIViewController & PageVCProtocol, isSelectedAll: Bool)] = []
    
    private var currentIdex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        
        dataSource = [
            (menu: "照片", imageName: "photo", content: photoVc, isSelectedAll: false),
            (menu: "视频", imageName: "video" , content: videoVc, isSelectedAll: false),
            (menu: "联系人", imageName: "contact" , content: contactVc, isSelectedAll: false),
            (menu: "日历", imageName: "calendar" , content: calendarVc, isSelectedAll: false),
            (menu: "文档", imageName: "file", content: fileVc, isSelectedAll: false)
        ]
        setupPageView()
        
        photoVc.delegate = self
        videoVc.delegate = self
        contactVc.delegate = self
        calendarVc.delegate = self
        fileVc.delegate = self
        headerView.rightButton.isHidden = true
    }
    
    private func setupSubviews() {
        title = "文件发送"
        headerView.setRightButton(with: "全选", target: self, action: #selector(selectAllItem))
        headerView.rightButton.setTitleColor( UIColor.pl_main, for: .normal)
        headerView.rightButton.setTitleColor( UIColor.pl_main, for: .highlighted)
    }
    
//    func selectedAll(with all: Bool) {
//        headerView.setRightButton(with: all ? "取消全选" : "全选", target: self, action: #selector(selectAllItem))
//    }
    
    
    @objc private func selectAllItem() {
        print(currentIdex)
        let vc = dataSource[safe: currentIdex]?.content
        let isSelectedAll = dataSource[currentIdex].isSelectedAll
        dataSource[currentIdex].isSelectedAll = !isSelectedAll
        headerView.setRightButton(with: !isSelectedAll ? "取消全选" : "全选", target: self, action: #selector(selectAllItem))
        headerView.rightButton.setTitleColor( UIColor.pl_main, for: .normal)
        headerView.rightButton.setTitleColor( UIColor.pl_main, for: .highlighted)
        guard let currentVc = vc else { return }
        currentVc.selectedAll(with: !isSelectedAll)
    }
    
    private func setupPageView() {
        menuController.register(type: OrderMenuCell.self, forCellWithReuseIdentifier: "identifier")
        menuController.view.backgroundColor = .white
        contentController.view.backgroundColor = .white
        menuController.menuView.layer.masksToBounds = false
        addChild(contentController)
        contentView.addSubview(contentController.view)
        contentController.didMove(toParent: self)

        addChild(menuController)
        contentView.addSubview(menuController.view)
        menuController.didMove(toParent: self)
        
        menuController.delegate = self
        menuController.dataSource = self
        
        contentController.scrollView.bounces = true
        contentController.view.backgroundColor = .clear
        contentController.dataSource = self
        contentController.delegate = self
        
        menuController.reloadData()
        contentController.reloadData()
        
        menuController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-9)
            make.height.equalTo(45)
        }
        
        contentController.view.snp.makeConstraints { (make) in
            make.top.equalTo(menuController.view.snp.bottom).offset(10)
            make.left.right.equalTo(menuController.view)
            make.bottom.equalToSuperview().offset(-LayoutConstants.xp_tabBarFullHeight())
        }
    }
}

extension SendViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }

    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index) as! OrderMenuCell
        cell.titleLabel.text = dataSource[index].menu
        cell.updateCurrrentImageStr(dataSource[index].imageName)
        cell.imageView.image = UIImage(named: dataSource[index].imageName)
        return cell
    }

    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return 90
    }
}

extension SendViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        currentIdex = page
        contentController.scroll(to: page, animated: true)
    }
    
//    func menuViewController(viewController: PagingMenuViewController, willDisplay cell: PagingMenuViewCell, forItemAt index: Int) {
//        if index == 0  { 
//            headerView.rightButton.isHidden = true
//        }
//    }
    
    func menuViewController(viewController: PagingMenuViewController, willAnimateFocusViewTo index: Int, with coordinator: PagingMenuFocusViewAnimationCoordinator) {
        currentIdex = index
        if index == 0 || index == 1 {
            headerView.rightButton.isHidden = true
        } else {
            headerView.rightButton.isHidden = false
        }
    }
}

// MARK: - Page Content

extension SendViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }

    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].content
    }
}

extension SendViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuController.scroll(index: index, percent: percent, animated: false)
        if index == 0 || index == 1 {
            headerView.rightButton.isHidden = true
        } else {
            headerView.rightButton.isHidden = false
        }
    }
}

extension SendViewController: CommContentVcDelegate {
    func contentViewControllerSend(_ vc: (UIViewController & TransferTaskManagerDelegate)) {
        if !TransferTaskManager.shared.isReady() {
            PLToast.showAutoHideHint("传输任务在进行中...")
            // 流转到状态界面
            TransferTaskManager.shared.jumpCurTransferPageVc()
        } else {
            TransferTaskManager.shared.delegate = vc
            let qrVc = QRCodeViewController()
            self.navigationController?.pushViewController(qrVc, animated: true)
        }
    }
    
    func showRightBtn(isHidden: Bool) {
//        headerView.rightButton.isHidden = isHidden
    }
}

