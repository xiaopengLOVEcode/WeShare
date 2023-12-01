//
//  CalendarViewModel.swift
//  WeShare
//
//  Created by XP on 2023/11/30.
//

import Foundation
import EventKit

struct CalendarModel {
    let event: EKEvent
    var isSelected: Bool
}

final class CalendarViewModel {

    var dataList: [CalendarModel] = []
    
    func selectedAll() {
        dataList = dataList.map { var newModel = $0; newModel.isSelected = true; return newModel }
    }
    
    func selectedItem(with index: Int, isSelected: Bool) {
        dataList[index].isSelected = isSelected
    }
    
    func modelForSelected() -> [EKEvent] {
        return []
    }
    
}
