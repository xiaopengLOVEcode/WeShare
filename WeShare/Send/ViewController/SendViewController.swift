//
//  SendViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import PagingKit
import UIKit

class SendViewController: PLBaseViewController {
    
    private let photoVc = PhotoViewController()
    private let videoVc = VideoViewController()
    private let contactVc = ContactViewController()
    private let calendarVc = CalendarViewController()
    private let fileVc = FileViewController()
    
    private let menuController = PagingMenuViewController()
    private let contentController = PagingContentViewController()
    private var dataSource: [(menu: String, imageName: String, content: UIViewController)] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        
        dataSource = [
            (menu: "照片", imageName: "photo", content: photoVc),
            (menu: "视频", imageName: "video" , content: videoVc),
            (menu: "联系人", imageName: "contact" , content: contactVc),
            (menu: "日历", imageName: "calendar" , content: calendarVc),
            (menu: "文档", imageName: "file", content: fileVc)
        ]
        setupPageView()
        
        photoVc.delegate = self
        videoVc.delegate = self
        contactVc.delegate = self
        calendarVc.delegate = self
        fileVc.delegate = self
    }
    
    private func setupSubviews() {
        title = "文件发送"
        headerView.setRightButton(with: "全选", target: self, action: #selector(selectAllItem))
        headerView.rightButton.setTitleColor( UIColor.pl_main, for: .normal)
        headerView.rightButton.setTitleColor( UIColor.pl_main, for: .highlighted)
    }
    
    
    @objc private func selectAllItem() {
        
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
        contentController.scroll(to: page, animated: true)
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
    }
}

extension SendViewController: PhotoViewControllerDelegate, VideoViewControllerDelegate, ContactViewControllerDelegate, CalendarViewControllerDelegate , FileViewControllerDelegate {
    func photoViewControllerSend() {
        let vc = SendingViewController(style: .send)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func videoViewControllerSend() {
        let vc = SendingViewController(style: .send)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func contactViewControllerSend() {
        let vc = SendingViewController(style: .send)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func calendarViewControllerSend() {
        let vc = SendingViewController(style: .send)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fileViewControllerSend() {
        let vc = SendingViewController(style: .send)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

