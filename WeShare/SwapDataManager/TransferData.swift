//
//  SwapData.swift
//  WeShare
//
//  Created by 朱国良 on 2023/11/25.
//

import Foundation
import Photos
import EventKit

extension PHAsset {
    /// 切记，不要在主线程中使用
    func map() -> TransferData? {
        var imageData: Data?
        // 使用DispatchSemaphore等待异步操作完成
        let semaphore = DispatchSemaphore(value: 0)
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImageDataAndOrientation(for: self, options: requestOptions) { data, _, _, _ in
            imageData = data
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        guard let data = imageData else { return nil }
        return TransferData(type: .photo, data: data)
    }
    
    func videoMap() -> TransferData? {
        var resData: Data?
        let semaphore = DispatchSemaphore(value: 0)
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        imageManager.requestAVAsset(forVideo: self, options: nil, resultHandler: { (avAsset, audioMix, info) in
            guard let avAsset = avAsset as? AVURLAsset else {
                return
            }
            do {
                // 获取视频文件的 Data
                let videoData = try Data(contentsOf: avAsset.url)
                resData = videoData
                semaphore.signal()
            } catch {
                print("无法将视频文件转换为 Data：\(error)")
                semaphore.signal()
            }
        })
        _ = semaphore.wait(timeout: .distantFuture)
        guard let data = resData else { return nil }
        return TransferData(type: .video, data: data)
    }
}

extension URL {
    func fileMap() -> TransferData? {
        var fileResData: Data?
        // 使用DispatchSemaphore等待异步操作完成
        let semaphore = DispatchSemaphore(value: 0)
        
        do {
            let isSecureAccess = self.startAccessingSecurityScopedResource()
            if isSecureAccess {
                let fileData = try Data(contentsOf: self)
                // 使用 fileData 进行进一步的处理
                print("成功读取文件数据，数据大小：\(fileData.count) 字节")
                fileResData = fileData
                self.stopAccessingSecurityScopedResource()
            }
            semaphore.signal()
            

        } catch {
            print("无法读取文件数据：\(error.localizedDescription)")
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        guard let data = fileResData else { return nil }
        return TransferData(type: .document, data: data)
    }
}


// 联系人
extension PPPersonModel {
    func map() -> TransferData? {
        var personData: Data?
        // 使用DispatchSemaphore等待异步操作完成
        let semaphore = DispatchSemaphore(value: 0)
        do {
            personData = try JSONEncoder().encode(self)
            semaphore.signal()
        } catch {
            print("Encoding failed: \(error)")
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        guard let data = personData else { return nil }
        return TransferData(type: .contact, data: data)
    }
}

// 视频


// 日历
extension EKEvent {
    func map() -> TransferData? {
        var eventData: Data?
        // 使用DispatchSemaphore等待异步操作完成
        let semaphore = DispatchSemaphore(value: 0)
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = true
//        requestOptions.deliveryMode = .highQualityFormat
//        PHImageManager.default().requestImageDataAndOrientation(for: self, options: requestOptions) { data, _, _, _ in
//            imageData = data
//            semaphore.signal()
//        }
        _ = semaphore.wait(timeout: .distantFuture)
        guard let data = eventData else { return nil }
        return TransferData(type: .contact, data: data)
    }
}

// 文件

extension String {
    func map() -> TransferData? {
        guard let data = data(using: .utf8) else { return nil }
        return TransferData(type: .text, data: data)
    }
}

final class TransferData: NSObject, NSCoding {
    enum DataType: Int32 {
        case photo
        case video
        case contact
        case calendar
        case document
        case text
    }
    
    let identifier: String
    let type: DataType
    let data: Data
    
    init(type: DataType, data: Data) {
        self.identifier = UUID().uuidString
        self.type = type
        self.data = data
    }
    
    // MARK: - NSCoding Methods
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encodeCInt(type.rawValue, forKey: "type")
        aCoder.encode(data, forKey: "data")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let typeRawValue = aDecoder.decodeCInt(forKey: "type")
        guard let identifier = aDecoder.decodeObject(forKey: "identifier") as? String,
              let type = DataType(rawValue: typeRawValue),
              let data = aDecoder.decodeObject(forKey: "data") as? Data
        else {
            return nil
        }
        
        self.identifier = identifier
        self.type = type
        self.data = data
    }
}

class ACKMessage: NSObject, NSCoding {
    let identifier: String
    init(identifier: String) {
        self.identifier = identifier
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: "identifier")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let identifier = aDecoder.decodeObject(forKey: "identifier") as? String else { return nil }
        self.identifier = identifier
    }
}

class ProgressMessage: NSObject, NSCoding {
    let progress: Double
    init(progress: Double) {
        self.progress = progress
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(progress, forKey: "progress")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let progress = aDecoder.decodeDouble(forKey: "progress")
        self.progress = progress
    }
}

func messageArchiver<T>(_ data: T) -> Data? where T : NSObject, T : NSCoding {
    let swapDataAsData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
    return swapDataAsData
}

func messageUnarchiver<T: NSObject>(_ data: Data, type: T.Type) -> T? where T: NSCoding {
    let unarchivedSwapData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    return unarchivedSwapData
}
