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

struct CalendarWrapper: Codable {
    let text: String
    let startDate: Date
    let endDate: Date
}

final class CalendarViewModel {

    var dataList: [CalendarModel] = []
    
    func selectedAll(with all: Bool) {
        dataList = dataList.map { var newModel = $0; newModel.isSelected = all; return newModel }
    }
    
    func selectedItem(with index: Int, isSelected: Bool) {
        dataList[index].isSelected = isSelected
    }
    
    func selectResources() -> [EKEvent] {
        return dataList.filter { $0.isSelected }.map { $0.event }
    }
}
