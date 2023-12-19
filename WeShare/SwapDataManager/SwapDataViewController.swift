//
//  SwapDataViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/25.
//

import UIKit
import RxSwift
import Photos

class SwapDataViewController: PLBaseViewController {

    private let bag = DisposeBag()
    
    lazy var advertisingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var browserStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        view.addSubview(advertisingStackView)
        advertisingStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(lineView.snp.left).offset(-5)
        }
        
        view.addSubview(browserStackView)
        browserStackView.snp.makeConstraints { make in
            make.top.equalTo(advertisingStackView)
            make.left.equalTo(lineView.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
        }
        
        setupAdvertisingViews()
        setupBrowserViews()
    }
    
    func setupAdvertisingViews() {
        let stateLabel = UILabel()
        stateLabel.textAlignment = .center
        stateLabel.numberOfLines = 0
        stateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        stateLabel.text = "数据接收方，点击下方按钮"
        advertisingStackView.addArrangedSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
        
        let receivedlabel = UILabel()
        receivedlabel.textAlignment = .left
        receivedlabel.numberOfLines = 0
        receivedlabel.font = UIFont.systemFont(ofSize: 16)
        receivedlabel.text = "接收到数据:"
        
        let progresslabel = UILabel()
        progresslabel.textAlignment = .left
        progresslabel.numberOfLines = 0
        progresslabel.font = UIFont.systemFont(ofSize: 16)
        progresslabel.text = "0.0"
        advertisingStackView.addArrangedSubview(progresslabel)
        
        let sender = UIButton(type: .custom)
        sender.backgroundColor = .orange
        sender.setTitleColor(UIColor.black, for: .normal)
        sender.setTitle("数据接收方", for: .normal)
        sender.rx.tap.subscribeNext { _ in
            SwapDataManager.shared.startAdvertising("换机助手") { [weak sender] state in
                guard let button = sender else { return }
                button.backgroundColor = .lightGray
                button.isEnabled = false
                receivedlabel.isHidden = true
                switch state {
                case .waiting:
                    stateLabel.text = "等待连接"
                case .connecting:
                    stateLabel.text = "连接中"
                case .connected:
                    stateLabel.text = "连接成功, 等待接受数据"
                    receivedlabel.isHidden = false
                case .notConnected:
                    stateLabel.text = "连接已断开"
                case .error:
                    stateLabel.text = "连接失败"
                    button.backgroundColor = .orange
                    button.isEnabled = true
                case .unknown:
                    stateLabel.text = "未知错误，请重试"
                    button.backgroundColor = .orange
                    button.isEnabled = true
                }
            }
        }.disposed(by: bag)
        advertisingStackView.addArrangedSubview(sender)
        sender.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        receivedlabel.isHidden = true
        advertisingStackView.addArrangedSubview(receivedlabel)
        
        SwapDataManager.shared.onDataReceived { [weak self] data in
            guard let self = self else { return }
            var text = "未知数据"
            switch data.type {
            case .calendar: text = "日历"
            case .contact: text = "联系人"
            case .document: text = "文档"
            case .photo: text = "照片"
            case .video: text = "视频"
            case .text: text = String(data: data.data, encoding: .utf8) ?? ""
            }
            let label = UILabel()
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = text
            self.advertisingStackView.addArrangedSubview(label)
        } progress: { progress in
            progresslabel.text = "\(progress)"
        }
    }
    
    func setupBrowserViews() {
        let stateLabel = UILabel()
        stateLabel.textAlignment = .center
        stateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        stateLabel.numberOfLines = 0
        stateLabel.text = "数据发送方，点击下方按钮"
        browserStackView.addArrangedSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
        
        let sendButton = UIButton(type: .custom)
        sendButton.backgroundColor = .orange
        sendButton.setTitleColor(UIColor.black, for: .normal)
        sendButton.setTitle("模拟发送数据", for: .normal)
        
        let progresslabel = UILabel()
        progresslabel.textAlignment = .left
        progresslabel.numberOfLines = 0
        progresslabel.font = UIFont.systemFont(ofSize: 16)
        progresslabel.text = "0.0"
        browserStackView.addArrangedSubview(progresslabel)
        
        let browser = UIButton(type: .custom)
        browser.backgroundColor = .orange
        browser.setTitleColor(UIColor.black, for: .normal)
        browser.setTitle("数据发送方", for: .normal)
        browser.rx.tap.subscribeNext { _ in
            SwapDataManager.shared.startBrowsing("换机助手") { [weak browser] state in
                guard let button = browser else { return }
                button.backgroundColor = .lightGray
                button.isEnabled = false
                sendButton.isHidden = true
                switch state {
                case .waiting:
                    stateLabel.text = "等待连接"
                case .connecting:
                    stateLabel.text = "连接中"
                case .connected:
                    stateLabel.text = "连接成功, 可以发送数据"
                    sendButton.isHidden = false
                case .notConnected:
                    stateLabel.text = "连接已断开"
                case .error:
                    stateLabel.text = "连接失败"
                    button.backgroundColor = .orange
                    button.isEnabled = true
                case .unknown:
                    stateLabel.text = "未知错误，请重试"
                    button.backgroundColor = .orange
                    button.isEnabled = true
                }
            }
        }.disposed(by: bag)
        browserStackView.addArrangedSubview(browser)
        browser.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        sendButton.isHidden = true
        sendButton.rx.tap.subscribeNext { _ in
            let sendDatas = ["数据1", "数据2", "数据3", "数据4", "数据5", "数据6"]
            let result = sendDatas.compactMap { $0.map() }
            SwapDataManager.shared.sendDatas(result) { progress in
                progresslabel.text = "\(progress)"
            }
        }.disposed(by: bag)
        browserStackView.addArrangedSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
    }
}
