//
//  PersistenceHelper.swift
//  Scheduler
//
//  Created by Brendon Crowe on 1/31/23.
//

import Foundation

enum DataPersistenceError: Error {
    case savingError(Error)
}


class PersistenceHelper {
    
    // CRUD - create, read, update, delete
    
    // array of events
    private static var events = [Event]()
    
    private static let filename = "schedules.plist"
    
    // create - save item to documents directory
    static func save(event: Event) throws { // make this function a throwing function by marking it with throws
        // 1. get url path to the file that item(e.g event) will be saved to
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        // 2. append new item/event to events array
        events.append(event)
        
        // 3. convert events array to Data object, which can be saved/ write to documents
        do {
            // convert (serialize) the events array to Data
            let data = try PropertyListEncoder().encode(events) // convert to Data (bytes)
            
            
            // 4. write/save the data to the documents directory
            try data.write(to: url, options: .atomic)
        } catch {
            // 5. throw an error
            throw DataPersistenceError.savingError(error)
        }
    }
    
    // read - load/retrieve items from documents directory
    
    // update
    
    // delete - remove item from documents directory
}
