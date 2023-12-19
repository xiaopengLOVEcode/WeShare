//
//  EventSaveTool.swift
//  WeShare
//
//  Created by XP on 2023/12/15.
//

import EventKit
import Foundation

final class EventSaveTool {
    func saveEvent(with data: Data) {
        let event = try? JSONDecoder().decode(CalendarWrapper.self, from: data)
        guard let model = event else { return }

        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: {
            granted, error in
            if granted && (error == nil) {
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = model.text
                event.startDate = model.startDate
                event.endDate = model.endDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch {
                    print("存储失败")
                }
            } else {
                print("没有授权")
            }
        })
    }
}
