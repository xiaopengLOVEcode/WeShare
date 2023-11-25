//
//  PhotoItemGroupModel.swift
//  WeShare
//
//  Created by XP on 2023/11/20.
//

import Foundation
import TZImagePickerController


class PhotoItemGroupModel {
    var bumModel: TZAlbumModel
    var isExpand: Bool
    var isSelectedAll: Bool
    
    init(bumModel: TZAlbumModel, isExpand: Bool, isSelectedAll: Bool) {
        self.bumModel = bumModel
        self.isExpand = isExpand
        self.isSelectedAll = isSelectedAll
    }
}
