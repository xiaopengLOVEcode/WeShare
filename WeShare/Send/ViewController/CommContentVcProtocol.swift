//
//  SubCommProtocol.swift
//  WeShare
//
//  Created by XP on 2023/11/23.
//

import Foundation

protocol CommContentVcDelegate: AnyObject{
    func showRightBtn(isHidden: Bool)
    func contentViewControllerSend(_ vc: (UIViewController & TransferTaskManagerDelegate))
}
