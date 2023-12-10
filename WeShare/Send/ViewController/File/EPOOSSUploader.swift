//
//  EPOOSSUploader.swift
//  Epoch
//
//  Created by xiezuoyu on 2022/5/29.
//  Copyright © 2022 com.epoch. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public typealias OSSUploadCompletion = (_ error: NSError?, _ resourceUrl: String?, _ resourceId: String?) -> Void

public typealias OSSUploadProgressHandler = (Progress, URL, UploadRequest) -> Void

public typealias OSSUploadRequestCreatHandler = (UploadRequest) -> Void

public enum OSSUploadDirectory: String {
    case avatar = "avatar"
    case keynote = "keynote"
    case log = "logs/ios"
}

@objc public enum OSSFileSuffix: Int, RawRepresentable {
    case heic
    case jpeg
    case jpg
    case png
    case zip
    case pdf
    case doc
    case docx
    case ppt
    case pptx
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .heic:
            return "heic"
        case .jpeg:
            return "jpeg"
        case .jpg:
            return "jpg"
        case .png:
            return "png"
        case .zip:
            return "zip"
        case .pdf:
            return "pdf"
        case .doc:
            return "doc"
        case .docx:
            return "docx"
        case .ppt:
            return "ppt"
        case .pptx:
            return "pptx"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "heic", "HEIC":
            self = .heic
        case "jpeg", "JPEG":
            self = .jpeg
        case "jpg", "JPG":
            self = .jpg
        case "png", "PNG":
            self = .png
        case "zip", "ZIP":
            self = .zip
        case "pdf", "PDF":
            self = .pdf
        case "doc", "DOC":
            self = .doc
        case "docx", "DOCX":
            self = .docx
        case "ppt", "PPT":
            self = .ppt
        case "pptx", "PPTX":
            self = .pptx
        default:
            return nil
        }
    }
}

public enum HTTPMimeType: String {
    case heic = "image/heic"
    case jpeg = "image/jpeg"
    case png = "image/png"
    case jpg = "application/x-jpg"
    case zip = "application/zip"
    case pdf = "application/pdf"
    case doc = "application/msword"
    case docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case ppt = "application/x-ppt"
    case pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
}
