//
//  FileViewController.swift
//  WeShare
//
//  Created by XP on 2023/11/6.
//

import Foundation
import UIKit
import RxSwift
import MobileCoreServices
import AVFoundation
import SnapKit
import PhotosUI

protocol FileViewControllerDelegate: SubCommProtocol {
    func fileViewControllerSend()
}

class FileViewController: UIViewController {
    
    
    // 文件最大 50 MB
    let allowedMaxFileSize = 20 * 1024 * 1024
    let maxPickedCount = 2
    let isOnlyImageOrPdf = false
    let isPptAndDocEnable = true
    
    private var documentPicker: UIDocumentPickerViewController?
    
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
                self.chooseFileAction()
            })
        ]
        SheetView.show(models: models)
    }

}

extension FileViewController {
    private func chooseFileAction() {
        let documentPicker: EPOUIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            if isOnlyImageOrPdf == false {
                if (isPptAndDocEnable) {
                    let docType: UTType = UTType(filenameExtension: "doc")! // UTType for .doc
                    let pptType: UTType = UTType(filenameExtension: "ppt")! // UTType for .ppt
                    let docxType: UTType = UTType(filenameExtension: "docx")! // UTType for .docx
                    let pptxType: UTType = UTType(filenameExtension: "pptx")! // UTType for .pptx
                    documentPicker = EPOUIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .png, .jpeg, .heic, docType, pptType, docxType, pptxType], asCopy: false)
                } else {
                    documentPicker = EPOUIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .png, .jpeg, .heic], asCopy: false)
                }
            } else {
                documentPicker = EPOUIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .png, .jpeg, .heic], asCopy: false)
            }
            
        } else {
            if isOnlyImageOrPdf == false {
                if (isPptAndDocEnable) {
                    documentPicker = EPOUIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypePNG), String(kUTTypeJPEG), "public.heic", "com.microsoft.word.doc", "com.microsoft.powerpoint.ppt", "org.openxmlformats.wordprocessingml.document", "org.openxmlformats.presentationml.presentation"], in: .import)
                } else {
                    documentPicker = EPOUIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypePNG), String(kUTTypeJPEG), "public.heic"], in: .import)
                }
            } else {
                documentPicker = EPOUIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypePNG), String(kUTTypeJPEG), "public.heic"], in: .import)
            }
        }
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        if #available(iOS 11.0, *) {
            // 设置可以多选
            documentPicker.allowsMultipleSelection = true
        }

        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        }

        self.documentPicker = documentPicker

        
        self.present(documentPicker, animated: true)
    }
}

extension FileViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        // Start accessing a security-scoped resource.
        let isSecureAccess = url.startAccessingSecurityScopedResource()

        // Make sure you release the security-scoped resource when you finish.
        defer {
            if isSecureAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }

        // Use file coordination for reading and writing any of the URL’s content.
        var error: NSError? = nil
        NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
            if let data = NSData(contentsOf: url) {
                if data.count <= 0 || data.count > allowedMaxFileSize {
//                    delegate?.failChooseFile(reason: .overSize, message: "Upload failed due to file size limitation (0-20M)", name: url.lastPathComponent)
                } else {
                    if let type = OSSFileSuffix(rawValue: url.pathExtension) {
//                        delegate?.didChooseFile?(data: data, type: type, name: url.lastPathComponent)
                    } else {
//                        delegate?.failChooseFile(reason: .formatNotSupported, message: nil, name: url.lastPathComponent)
                    }
                }
            } else {
//                delegate?.failChooseFile(reason: .notExist, message: nil, name: url.lastPathComponent)
            }
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if maxPickedCount != 0, urls.count > maxPickedCount {
//            delegate?.failChooseFile(reason: .overMaxPickedCount, message: "Upload up to 10 files.", name: nil)
            return
        }
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        var dataList: [NSData] = []
        var typesList: [String] = []
        var namesList: [String] = []
        for (_, url) in urls.enumerated() {
            // Start accessing a security-scoped resource.
            let isSecureAccess = url.startAccessingSecurityScopedResource()

            // Make sure you release the security-scoped resource when you finish.
            defer {
                if isSecureAccess {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            // Use file coordination for reading and writing any of the URL’s content.
            var error: NSError? = nil
            NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
                if let data = NSData(contentsOf: url) {
                    if data.count <= 0 || data.count > allowedMaxFileSize {
                        if urls.count > 1 {
                            PLToast.showAutoHideHint("Partial upload failed due to file size limitation (0-20M)")
                        } else if urls.count == 1 {
                            PLToast.showAutoHideHint("Partial upload failed due to file size limitation (0-20M)")
                        }
                    } else {
                        if let type = OSSFileSuffix(rawValue: url.pathExtension) {
                            dataList.append(data)
                            typesList.append(type.rawValue)
                            namesList.append(url.lastPathComponent)
                            
                        } else {
//                            delegate?.failChooseFile(reason: .formatNotSupported, message: nil, name: url.lastPathComponent)
                            
                        }
                    }
                } else {
//                    delegate?.failChooseFile(reason: .notExist, message: nil, name: url.lastPathComponent)
                    
                }
            }
        }
//        delegate?.didChooseFiles?(dataList: dataList, typesList: typesList, namesList: namesList)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
//        delegate?.failChooseFile(reason: .cancel, message: nil, name: nil)
    }
}


extension FileViewController: PageVCProtocol {
    func selectedAll() {}
}
