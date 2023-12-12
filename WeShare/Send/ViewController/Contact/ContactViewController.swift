//
//  ContactViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import RxSwift
import UIKit
import Contacts

protocol ContactViewControllerDelegate: SubCommProtocol {
    func contactViewControllerSend()
}

class ContactViewController: UIViewController {
    weak var delegate: ContactViewControllerDelegate?

    private let bag = DisposeBag()

    private let vm = ContactViewModel()

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
        
        self.requestContactsPermission { [weak self] grant in
            guard let self = self else { return }
            if grant {
                PPGetAddressBook.getOrderAddressBook(addressBookInfo: { addressBookDict, nameKeys in
                    self.vm.addressBookSouce = addressBookDict // 所有联系人信息的字典
                    self.vm.keysArray = nameKeys // 所有分组的key值
                    // 刷新tableView
                    self.tableView.reloadData()
                }, authorizationFailure: {
                    let alertView = UIAlertController(title: "提示", message: "请在iPhone的“设置-隐私-通讯录”选项中，允许访问您的通讯录", preferredStyle: UIAlertController.Style.alert)
                    let confirm = UIAlertAction(title: "知道啦", style: UIAlertAction.Style.cancel, handler: nil)
                    alertView.addAction(confirm)
                    self.present(alertView, animated: true, completion: nil)
                })
            } else {
                let alertView = UIAlertController(title: "提示", message: "请在iPhone的“设置-隐私-通讯录”选项中，允许访问您的通讯录", preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "知道啦", style: UIAlertAction.Style.cancel, handler: nil)
                alertView.addAction(confirm)
                self.present(alertView, animated: true, completion: nil)
            }
        }
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.showRightBtn(isHidden: false)
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
                self.delegate?.contactViewControllerSend()
            }
        }.disposed(by: bag)
    }
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.rowCountFor(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.keysArray.count
    }

    // 右侧索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return vm.keysArray
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = ContactCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ContactCell
        if cell == nil {
            cell = ContactCell(style: .subtitle, reuseIdentifier: identifier)
        }
        cell?.didSelectItemBlock = { [weak self] isSelected in
            guard let self = self else { return }
            self.vm.selected(indexPath: indexPath, isSelected: isSelected)
        }
        let model = vm.modelFor(indexPath: indexPath)
        cell?.bindData(model: model)
        return cell!
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: LayoutConstants.deviceWidth, height: 44)
        let letterLabel = UILabel()
        letterLabel.font = .boldFont(14)
        letterLabel.textColor = UIColor(hex: 0x000E1F)
        headerView.addSubview(letterLabel)
        letterLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(64)
            make.centerY.equalToSuperview()
        }
        letterLabel.text = vm.sectioNameFor(section: section)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    // 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ContactViewController: PageVCProtocol {
    func selectedAll() {
        vm.selectedAll()
        tableView.reloadData()
    }
}

extension ContactViewController {
    func requestContactsPermission(completion: @escaping ((Bool) ->Void)) {
        let contactStore = CNContactStore()

        // 检查是否已经授权
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            // 已经授权，可以访问通讯录
            completion(true)
            break
        case .denied, .restricted:
            // 用户拒绝或受限制，弹出提示或者引导用户打开设置中的权限
            completion(false)
            showPermissionAlert()
        case .notDetermined:
            // 请求授权
            contactStore.requestAccess(for: .contacts) { granted, _ in
                if !granted {
                    self.showPermissionAlert()
                }
                completion(granted)
            }
        default:
            break
        }
    }

    func showPermissionAlert() {
        // 在这里显示一个提示，引导用户打开设置中的权限
        let alertView = UIAlertController(title: "提示", message: "请在iPhone的“设置-隐私-通讯录”选项中，允许访问您的通讯录", preferredStyle: UIAlertController.Style.alert)
        let confirm = UIAlertAction(title: "知道啦", style: UIAlertAction.Style.cancel, handler: nil)
        alertView.addAction(confirm)
        self.present(alertView, animated: true, completion: nil)
    }
}
