//
//  TransferTaskManager.swift
//  WeShare
//
//  Created by XP on 2023/12/1.
//

import Foundation
import RxSwift
import RxCocoa

protocol TransferTaskManagerDelegate: AnyObject {
    func transferTaskManagerGetDatas() -> [TransferData]
    // 存放数据
    func transferTaskManagerDatasReceive(datas: [TransferData])
}


final class TransferTaskManager: NSObject {
    
    static let startTransFerTask = NSNotification.Name(rawValue: "startTransFerTask")
    
    static let cancelTransFerTask = NSNotification.Name(rawValue: "cancelTransFerTask")
    
    enum State {
        case idle               // 空闲态
        case progress           // 传输中 or 接收中
        case complete           // 完成 单次任务
    }
    
    private let notiBag = DisposeBag()

    // 单例实例
    static let shared = TransferTaskManager()
    
    private var state: State = .idle
    
    weak var delegate: TransferTaskManagerDelegate?
    
    
    // 持有接受和发送界面 保持一个实例
    private var sendVC: SendingViewController?
    
    private var receiveVC: SendingViewController?
    
    override init() {
        // 监听各个任务的执行状态
        super.init()
        
    }
    
    // 空闲状态下才可以传输数据
    func isReady() -> Bool {
        return state == .idle || state == .complete
    }
    
    func sendDatas(_ datas: [TransferData]) {
        SwapDataManager.shared.sendDatas(datas) { [weak self]progress in
            guard let self = self else { return }
            // 同步进度
            print(progress)
            if progress == 1 {
                self.state = .complete
            }
        }
    }
    
    func onDataReceived(dataReceived: @escaping (TransferData) -> Void, progress: @escaping (Double) -> Void) {

    }
    
    func jumpCurTransferPageVc() {
        guard let curVC = sendVC else { return }
        guard let fromVc = PLViewControllerUtils.currentTopController() else { return }
        fromVc.navigationController?.pushViewController(curVC, animated: true)
    }
}

// 发送
extension TransferTaskManager {
    func startConnect() {
        SwapDataManager.shared.startBrowsing("换机助手") { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .waiting:
                PLToast.showAutoHideHint("等待连接")
            case .connecting:
                PLToast.showAutoHideHint("连接中")
            case .connected:
                PLToast.showAutoHideHint("连接成功, 可以发送数据")
                self.startSendingData()
            case .notConnected:
                PLToast.showAutoHideHint("连接已断开")
//                SwapDataManager.shared.stopServices()
            case .error:
                PLToast.showAutoHideHint("连接失败")
            case .unknown:
                PLToast.showAutoHideHint("未知错误，请重试")
            }
        }
    }
    
    func startSendingData() {
        DispatchQueue.main.async { [weak self] in
            // 先做一次性任务
            guard let self = self else { return }
            self.sendVC = SendingViewController(style: .send)
            guard let cur_VC = self.sendVC else { return }
            guard let fromVc = PLViewControllerUtils.currentTopController() else { return }
            fromVc.navigationController?.pushViewController(cur_VC, animated: true)
            var vcs = fromVc.navigationController?.viewControllers ?? []
            guard vcs.isNotEmpty else { return }
            vcs.remove(at: vcs.count - 2)
            fromVc.navigationController?.viewControllers = vcs
            // 直接传输
            let datas = delegate?.transferTaskManagerGetDatas()
            guard let transferDatas = datas  else {
                PLToast.showAutoHideHint("数据处理失败")
                return
            }
            self.sendDatas(transferDatas)
        }
    }
}

// 接收
extension TransferTaskManager {
    func startlisten() {
        SwapDataManager.shared.startAdvertising("换机助手") { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .waiting:
                PLToast.showAutoHideHint("等待连接")
            case .connecting:
                PLToast.showAutoHideHint("连接中")
            case .connected:
                PLToast.showAutoHideHint("连接成功, 等待接受数据")
                self.startRevieveData()
            case .notConnected:
                PLToast.showAutoHideHint("连接已断开")
                SwapDataManager.shared.stopServices()
            case .error:
                PLToast.showAutoHideHint("连接失败")
            case .unknown:
                PLToast.showAutoHideHint("未知错误，请重试")
            }
        }
    }
    
    private func startRevieveData() {
        self.receiveVC = SendingViewController(style: .receive)
        guard let cur_VC = self.receiveVC else { return }
        guard let fromVc = PLViewControllerUtils.currentTopController() else { return }
        fromVc.navigationController?.pushViewController(cur_VC, animated: true)
        onDataReceived()
    }
    
    private func onDataReceived() {
        // 这时候代理为空 不知道哪个页面该进行工作
        SwapDataManager.shared.onDataReceived { [weak self] data in
            guard let self = self else { return }
            var text = "未知数据"
            switch data.type {
            case .calendar:
                print("calendar")
            case .contact:
                ContactSaveTool.addContact(with: [])
            case .document:
                print("document")
            case .photo:
                print("photo")
            case .video:
                print("video")
            case .text:
                print("text")
            }
        } progress: { _ in
            
        }
    }
}
