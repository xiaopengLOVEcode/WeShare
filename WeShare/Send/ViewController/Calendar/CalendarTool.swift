//
//  CalendarTool.swift
//  WeShare
//
//  Created by XP on 2023/11/22.
//

import EventKit

class CalendarManager {
    private let eventStore = EKEventStore()

    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, _ in
            completion(granted)
        }
    }

    func fetchReminders(completion: @escaping ([EKEvent]?) -> Void) {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: 0, to: Date())!
        let endDate = calendar.date(byAdding: .month, value: 1, to: Date())!
        
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)
        
        let res = events.filter { $0.calendar.type == .local }
        
        DispatchQueue.main.async {
            completion(res)
        }
    }
}
