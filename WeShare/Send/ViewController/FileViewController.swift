//
//  FileViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import UIKit
import RxSwift

protocol FileViewControllerDelegate: SubCommProtocol {
    func fileViewControllerSend()
}

class FileViewController: UIViewController {
    
    private let noFileLabel = UILabel().then {
        $0.text = "暂无文档"
        $0.font = .font(14)
    }
    
    private let importBtn = UIButton().then {
        $0.setTitle("导入文档", for: .normal)
        $0.setTitle("导入文档", for: .highlighted)
        $0.setTitleColor(UIColor.pl_main, for: .normal)
        $0.setTitleColor(UIColor.pl_main, for: .highlighted)
        $0.titleLabel?.font = .font(16)
    }
    
    weak var delegate: FileViewControllerDelegate?
    
    private let bag = DisposeBag()
    
    private let bottomBtn = GradientButton().then {
        $0.applyAriesStyle()
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.setTitle("开始发送", for: .normal)
        $0.setTitle("开始发送", for: .highlighted)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        addHandleEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.showRightBtn(isHidden: false)
    }

    private func setupSubviews() {
        
        view.addSubview(noFileLabel)
        noFileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(232)
        }
        
        view.addSubview(importBtn)
        importBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noFileLabel.snp.bottom).offset(8)
        }
        
        
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func addHandleEvent() {
        bottomBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.fileViewControllerSend()
        }.disposed(by: bag)
        
        importBtn.rx.controlEvent(.touchUpInside).subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.showMenu()
        }.disposed(by: bag)
    }
    
    private func showMenu() {
        let models = [
            SheetView.Model(title: "本地文件", selected: false, handle: {
            })
        ]
        SheetView.show(models: models)
    }

}
