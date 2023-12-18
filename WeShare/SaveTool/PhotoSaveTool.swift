//
//  PhotoSaveTool.swift
//  WeShare
//
//  Created by XP on 2023/12/15.
//

import Foundation
import TZImagePickerController

final class PhotoSaveTool {
    // 单个资源
    static func addImage(with imageData: Data) {
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
        }) { success, error in
            if success {
                // 获取保存后的PHAsset
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                if let firstAsset = fetchResult.firstObject {
                    print("成功保存到照片库，对应的PHAsset是: \(firstAsset)")
                    // 在这里你可以将firstAsset传递给其他需要的地方
                } else {
                    print("未能获取保存后的PHAsset")
                }
            } else {
                print("保存到照片库失败，错误：\(error?.localizedDescription ?? "未知错误")")
            }
        }
    }
    
    
    static func addVideo(with data: Data) {
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mp4")

        do {
            try data.write(to: fileURL, options: .atomic)
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            }, completionHandler: { (success, error) in
                if success {
                    print("视频保存到相册成功")
                } else {
                    if let error = error {
                        print("保存视频到相册失败：\(error.localizedDescription), code: \(error._code)")
                    } else {
                        print("保存视频到相册失败，未知错误")
                    }
                }
            })
        } catch {
            print("保存视频到本地文件失败：\(error.localizedDescription)")
        }
    }
}
