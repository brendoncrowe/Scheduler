//
//  EventData.swift
//  Scheduler
//
//  Created by Brendon Crowe on 12/27/22.
//

import Foundation


struct Event: Codable {
    var name: String
    var date: Date
    
    static func getTestData() -> [Event] {
        var events = [Event]()
        let eventNames = ["Hanging out with friends 🤙🏻", "Workout 🏋🏼", "Study Swift 📖", "Spend time with family", "Date night with the wife", "Buy a new thing", "Spend time relaxing"]
        
        for eventName in eventNames {
            let event = Event(name: eventName, date: Date())
            events.append(event)
        }
        return events
    }
}
