//
//  WeShareWebViewController.swift
//  WeShare
//
//  Created by XP on 2023/12/6.
//

import Foundation


import WebKit

final class WebViewController: PLBaseViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建 WKWebView
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self

        // 添加 WKWebView 到视图中
        view.addSubview(webView)

        // 设置 WKWebView 的约束，充满整个视图
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // 加载指定的 URL
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - WKNavigationDelegate

    // 可选：可以通过实现这些方法来处理 WebView 导航事件，例如页面加载完成、加载失败等
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("页面加载完成")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败，错误：\(error)")
    }
}

extension WebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler()
        }))
        PLViewControllerUtils.currentTopController()?.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        PLViewControllerUtils.currentTopController()?.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
        alertController.addTextField {
            $0.placeholder = defaultText
            $0.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(alertController.textFields?.last?.text ?? "")
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            completionHandler(nil)
        }))
        PLViewControllerUtils.currentTopController()?.present(alertController, animated: true, completion: nil)
    }
}
