//
//  TabBarItem.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/27.
//

import UIKit

final class TabBarItem: UITabBarItem {
    enum Page: Int {
        case unknown = -1
        case send = 0
        case recieve = 1
        case setting = 2
    }
    
    private(set) var page: Page = .unknown
    private(set) var vc: UIViewController?
    
    convenience init(page: Page, vc: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) {
        self.init()
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.page = page
        self.vc = vc
    }
}
