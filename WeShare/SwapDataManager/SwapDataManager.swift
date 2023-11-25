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
    private var myPeerID: MCPeerID!
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    // 数据发送方需要使用的字段
    private var discoveryId = ""
    private var toPeerId: MCPeerID?
    
    // 数据传输回调闭包
    var onDataReceived: ((String) -> Void)?
    /// 连接状态变化
    var stateCallback: ((SessionState) -> Void)?
    
    // 服务类型
    private let serviceType = "weshare"
    
    // 初始化方法
    private override init() {
        super.init()
        // 初始化Peer ID和Session
        myPeerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
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
    
    // 发送数据
    func sendData(_ data: String) {
        guard let peerID = toPeerId, session.connectedPeers.contains(peerID) else {
            // 如果设备未连接，可以在此处进行处理
            return print("[error] 未连接到设备，无法发送数据")
        }
        if let dataToSend = data.data(using: .utf8) {
            do {
                try session.send(dataToSend, toPeers: [peerID], with: .reliable)
            } catch {
                print("Error sending data: \(error.localizedDescription)")
            }
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
        if let receivedString = String(data: data, encoding: .utf8) {
            // 使用 onDataReceived 回调将数据传递给外部
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onDataReceived?(receivedString)
            }
        }
    }
    
    // 其他MCSessionDelegate方法可以根据需要实现
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

