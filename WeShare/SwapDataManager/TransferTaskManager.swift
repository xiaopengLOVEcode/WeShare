//
//  TransferTaskManager.swift
//  WeShare
//
//  Created by XP on 2023/12/1.
//

import Foundation
import RxSwift
import RxCocoa


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
    
    var state: State = .idle
    
    override init() {
        // 监听各个任务的执行状态
        super.init()
        
    }
    
    // 空闲状态下才可以传输数据
    func isReady() -> Bool {
        return state == .idle || state == .complete
    }
    
    func sendDatas(_ datas: [TransferData], progress: @escaping (Double) -> Void) {
        SwapDataManager.shared.sendDatas(datas) { progress in
            print(progress)
        }
    }
    
    func onDataReceived(dataReceived: @escaping (TransferData) -> Void, progress: @escaping (Double) -> Void) {
        SwapDataManager.shared.onDataReceived { data in
            
        } progress: { _ in
            print(progress)
        }
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
                SwapDataManager.shared.stopServices()
            case .error:
                PLToast.showAutoHideHint("连接失败")
            case .unknown:
                PLToast.showAutoHideHint("未知错误，请重试")
            }
        }
    }
    
    func startSendingData() {
        DispatchQueue.main.async {
            // 先做一次性任务
            let vc = SendingViewController(style: .send)
            guard let fromVc = PLViewControllerUtils.currentTopController() else { return }
            fromVc.navigationController?.pushViewController(vc, animated: true)
            var vcs = fromVc.navigationController?.viewControllers ?? []
            guard vcs.isNotEmpty else { return }
            vcs.remove(at: vcs.count - 2)
            fromVc.navigationController?.viewControllers = vcs
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
        let vc = SendingViewController(style: .receive)
        guard let fromVc = PLViewControllerUtils.currentTopController() else { return }
        fromVc.navigationController?.pushViewController(vc, animated: true)
    }
}
