//
//  PhotoUtil.swift
//  WeShare
//
//  Created by XP on 2023/12/13.
//

import Foundation
import Photos

class PhotoUtil {
    
    static func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            completion(true)
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    let granted = status == .authorized
                    if !granted {
                        showPermissionAlert()
                    }
                    completion(granted)
                }
            }
        }
    }
    
    private static func showPermissionAlert() {
        let alertController = UIAlertController(
            title: "Permission Required",
            message: "Please grant permission to access contacts in Settings.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        
        guard let topVC = PLViewControllerUtils.currentTopController() else { return }
        topVC.present(alertController, animated: true, completion: nil)
    }
}
