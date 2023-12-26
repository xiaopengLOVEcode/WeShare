//
//  CalendarViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import UIKit
import RxSwift

class CalendarViewController: UIViewController {
    private let vm = CalendarViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.sectionIndexColor = UIColor.pl_main
        tableView.adaptToIOS11()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    weak var delegate: CommContentVcDelegate?
    
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
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.showRightBtn(isHidden: false)
    }
    
    private func requestData() {
        // 示例用法
         let calendarManager = CalendarManager()
         calendarManager.requestCalendarAccess { granted in
            if granted {
                calendarManager.fetchReminders { [weak self] reminders in
                    guard let self = self else { return }
                    if let reminders = reminders {
                        self.vm.dataList = reminders.map({ reminder in
                            return CalendarModel(event: reminder, isSelected: false)
                        })
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print("Calendar access not granted.")
            }
         }
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
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
            let array = self.vm.selectResources()
            if array.isEmpty {
                PLToast.showAutoHideHint("未选中资源")
            } else {
                self.delegate?.contentViewControllerSend(self)
            }
        }.disposed(by: bag)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = CalendarCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CalendarCell
        if cell == nil {
            cell = CalendarCell(style: .subtitle, reuseIdentifier: identifier)
        }
        cell?.didSelectItemBlock = { [weak self] isSelected in
            guard let self = self else { return }
            self.vm.selectedItem(with: indexPath.row, isSelected: isSelected)
        }
        let model = vm.dataList[indexPath.row]
        cell?.bindData(with: model)
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}

extension CalendarViewController: TransferTaskManagerDelegate {
    func transferTaskManagerGetDatas() -> [TransferData] {
        return vm.selectResources().compactMap {  $0.map() }
    }
    
    func transferTaskManagerDatasReceive(datas: [TransferData]) {
        
    }
}

extension CalendarViewController: PageVCProtocol {
    func selectedAll(with all: Bool) {
        vm.selectedAll(with: all)
        tableView.reloadData()
    }
}

extension CalendarViewController:  CalendarCellProtocol {
    func calendarCellBtnClick() {
        
    }
}
