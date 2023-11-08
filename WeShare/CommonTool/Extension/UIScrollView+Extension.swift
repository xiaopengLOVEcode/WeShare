//
//  UIScrollView+Extension.swift
//  PowerLoans
//
//  Created by Neo on 2023/9/5.
//

import Foundation

extension UIScrollView {
    func adaptToIOS11() {
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
}

public extension UIScrollView {
//    func pl_addCommonHeaderView(refreshing: @escaping (_ endRefresh: @escaping () -> Void) -> Void, end: @escaping () -> Void) {
//        mj_header = {
//            let header = ARSCommonRrefreshHeader()
//            let endRefreshBlock = {
//                header.endRefreshing()
//            }
//            header.refreshingBlock = {
//                refreshing(endRefreshBlock)
//            }
//            header.endRefreshingCompletionBlock = {
//                end()
//            }
//            return header
//        }()
//    }
}

