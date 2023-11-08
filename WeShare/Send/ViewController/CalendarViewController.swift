//
//  CalendarViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import UIKit
import RxSwift

protocol CalendarViewControllerDelegate: AnyObject {
    func calendarViewControllerSend()
}

class CalendarViewController: UIViewController {
    
    weak var delegate: CalendarViewControllerDelegate?
    
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
    
    
    private func setupSubviews() {
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
            self.delegate?.calendarViewControllerSend()
        }.disposed(by: bag)
    }

}
