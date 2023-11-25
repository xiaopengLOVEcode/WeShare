//
//  SwapDataManager.swift
//  WeShare
//
//  Created by 朱国良 on 2023/11/25.
//

import MultipeerConnectivity

/// 数据交换服务
/// A设备给B设备同步数据(A -> B), A设备就是浏览者，B设备就是广播者，等两台设备建立连接后就可以发送数据
final class SwapDataManager: NSObject {
    enum SessionState {
        case waiting
        case connecting
        case connected
        case notConnected
        case unknown
        case error
    }
    
    // 单例实例
    static let shared = SwapDataManager()
    
    // MultipeerConnectivity相关属性
    private var myPeerID: MCPeerID
    private var session: MCSession
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    // 数据发送方需要使用的字段
    private var discoveryId = ""
    private var toPeerId: MCPeerID?
    
    // 数据传输回调闭包
    var dataReceived: ((TransferData) -> Void)?
    /// 连接状态变化
    var stateCallback: ((SessionState) -> Void)?
    /// 进度
    private var progress: ((Double) -> Void)?
    // 服务类型
    private let serviceType = "weshare"
    
    private var operations: [SendDataOperation] = []
    private let operationQueue: OperationQueue
    private let serialQueue: DispatchQueue
    // 初始化方法
    private override init() {
        serialQueue = DispatchQueue(label: "weshare.sendData.queue", qos: .default)
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        // 初始化Peer ID和Session
        myPeerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }
    
    /// 开始广播服务
    /// discoveryId: 可以理解为数据接收方，需要生成一个唯一标识符，在局域网中所有的浏览者（数据发送方）根据这个唯一标识符来建立连接
    func startAdvertising(_ discoveryId: String, stateCallback: @escaping (SessionState) -> Void) {
        guard self.stateCallback == nil else { return }
        self.stateCallback = stateCallback
        let advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["discoveryId": discoveryId], serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        self.advertiser = advertiser
        stateCallback(.waiting)
    }
    
    /// 开始浏览服务
    /// discoveryId: 浏览者（数据发送方）要根据这个ID来确定和局域网中的哪个设备建立连接。
    func startBrowsing(_ discoveryId: String, stateCallback: @escaping (SessionState) -> Void) {
        guard self.stateCallback == nil else { return }
        self.discoveryId = discoveryId
        self.stateCallback = stateCallback
        let browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        self.browser = browser
        stateCallback(.waiting)
    }
    
    // 停止广播和浏览服务
    func stopServices() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session.disconnect()
        self.stateCallback = nil
    }

    // MARK: - 发送方函数
    /// 批量发送数据
    /// - Parameters:
    ///   - datas: 批量数据
    ///   - progress: 发送进度
    func sendDatas(_ datas: [TransferData], progress: @escaping (Double) -> Void) {
        guard operations.isEmpty else {
            return print("[debug] 队列忙，请稍后再试")
        }
        self.progress = progress
        operations = datas.map { data in
           let operation = SendDataOperation(id: data.identifier) { [weak self] op in
               guard let dataToSend = messageArchiver(data) else {
                    op.reportSuccess()
                    return print("[error] 数据转换错误")
                }
               self?.sendDataIMP(data: dataToSend, errorCallback: {
                   op.reportSuccess()
               })
            }
            self.operationQueue.addOperation(operation)
            return operation
        }
        operationQueue.progress.totalUnitCount = Int64(operations.count)
        // 队列任务执行完
        operationQueue.addBarrierBlock { [weak self] in
            guard let self = self else { return }
            print("[debug] 数据发送完成")
            self.operations.removeAll()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.progress?(1.0)
                self.sendReceivedProgress(1.0)
            }
        }
    }
    
    // MARK: - 接收方函数
    /// 接收数据
    /// - Parameters:
    ///   - dataReceived: 收到的数据
    ///   - progress: 数据接收方进度
    func onDataReceived(dataReceived: @escaping (TransferData) -> Void, progress: @escaping (Double) -> Void) {
        self.progress = progress
        self.dataReceived = dataReceived
    }
}

// MARK: - Private
private extension SwapDataManager {
    /// 接收数据方，发送ACK
    /// - Parameter ack: 文件的id
    func sendACK(_ ack: String) {
        guard let data = messageArchiver(ACKMessage(identifier: ack)) else { return }
        sendDataIMP(data: data) {}
    }
    
    /// 给数据接收方发送当前进度
    func sendReceivedProgress(_ fractionCompleted: Double) {
        guard let data = messageArchiver(ProgressMessage(progress: fractionCompleted)) else { return }
        sendDataIMP(data: data) {}
    }
    
    func sendDataIMP(data dataToSend: Data, errorCallback: () -> Void) {
        guard let peerID = toPeerId, session.connectedPeers.contains(peerID) else {
            // 如果设备未连接，可以在此处进行处理
            errorCallback()
            return print("[error] 未连接到设备，无法发送数据")
        }
        do {
            try session.send(dataToSend, toPeers: [peerID], with: .reliable)
        } catch {
            errorCallback()
            print("Error sending data: \(error.localizedDescription)")
        }
    }
}

// MARK: - MCSessionDelegate
extension SwapDataManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .notConnected:
                self.stateCallback?(.notConnected)
                
            case .connecting:
                self.stateCallback?(.connecting)
                
            case .connected:
                self.toPeerId = peerID
                self.stateCallback?(.connected)
                
            @unknown default:
                self.stateCallback?(.unknown)
                self.stopServices()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    // 实现MCSessionDelegate的方法来处理数据传输
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // 判断收到的是否为ACK类型数据
        if let ack = messageUnarchiver(data, type: ACKMessage.self)?.identifier {
            guard ack != "close_message" else {
                return stopServices()
            }
            // 判断收到的数据是否为ACK
            self.operations.filter { $0.id == ack }.forEach { $0.reportSuccess() }
            // 数据发送方的进度回调
            let fractionCompleted = self.operationQueue.progress.fractionCompleted
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.progress?(fractionCompleted)
            }
            // 同时给数据接收方，发送下进度
            self.sendReceivedProgress(fractionCompleted)
            return
        }
        
        // 是否为SwapData类型数据
        if let swapData = messageUnarchiver(data, type: TransferData.self) {
            // 发送ACK
            self.sendACK(swapData.identifier)
            // 使用 onDataReceived 回调将数据传递给外部
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dataReceived?(swapData)
            }
            return
        }
        
        // 进度数据
        if let fractionCompleted = messageUnarchiver(data, type: ProgressMessage.self)?.progress {
            // 数据接收方的进度回调
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.progress?(Double(fractionCompleted))
                self.sendACK("close_message")
                self.stopServices()
            }
        }
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension SwapDataManager: MCNearbyServiceAdvertiserDelegate {
    // 实现MCNearbyServiceAdvertiserDelegate的方法来处理广播服务
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stateCallback?(.error)
            self.stopServices()
        }
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension SwapDataManager: MCNearbyServiceBrowserDelegate {
    // 实现MCNearbyServiceBrowserDelegate的方法来处理浏览服务
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let discoveryId = info?["discoveryId"] as? String, discoveryId == self.discoveryId else { return }
        // 只和相同的discoveryId的设备建立连接
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stateCallback?(.error)
            self.stopServices()
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // 处理设备断开连接的情况
    }
}

