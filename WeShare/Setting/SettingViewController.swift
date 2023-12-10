//
//  SettingViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import UIKit

class SettingViewController: PLBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }

    private func setupSubviews() {
        title = "设置"
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .equalSpacing
            $0.spacing = 24
            $0.backgroundColor = .white
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }

        let entries = createEntryViews()
        for entry in entries {
            stackView.addArrangedSubview(entry)
            entry.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(24)
            }
        }
    }

    private func createEntryViews() -> [EntryView] {
        var entries: [EntryView] = []
        let shareData = EntryData.arrow("分享给好友", "share") { [weak self] in
            guard let self = self else { return }
            let vc = IntroduceController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let shareEntry = EntryView(with: shareData)

        let commentData = EntryData.arrow("给个好评", "comment") { [weak self] in
            guard let self = self else { return }
        }
        let commentEntry = EntryView(with: commentData)

        let messageData = EntryData.arrow("联系我们", "message") { [weak self] in
            guard let self = self else { return }
            self.showAlert()
        }
        let messageEntry = EntryView(with: messageData)

        let aboutData = EntryData.arrow("关于我们", "about") { [weak self] in
            guard let self = self else { return }
            let vc = AboutViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let aboutEntry = EntryView(with: aboutData)

        let agreenmentData = EntryData.arrow("用户协议", "agreemnet") { [weak self] in
            guard let self = self else { return }
            let vc = WebViewController(url: URL(string: "https://www.freeprivacypolicy.com/live/8131e8da-35e3-4d77-b1fd-3bbd94759871")!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let agreenmentEntry = EntryView(with: agreenmentData)

        let policyData = EntryData.arrow("隐私政策", "policy") { [weak self] in
            guard let self = self else { return }
            let vc = WebViewController(url: URL(string: "https://www.freeprivacypolicy.com/live/a6f09528-b94e-4715-880b-8334f09372dc")!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let policyEntry = EntryView(with: policyData)

        entries += [
            shareEntry,
            commentEntry,
            messageEntry,
            aboutEntry,
            agreenmentEntry,
            policyEntry,
        ]
        return entries
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "联系我们",
            message: "邮箱： haoxunnet@outlook.com",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "确认", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
