//
//  PersistenceHelper.swift
//  Scheduler
//
//  Created by Brendon Crowe on 1/31/23.
//

import Foundation

enum DataPersistenceError: Error {
    case savingError(Error)
    case fileDoesNotExist(String) // give back the string for the filename
    case noData
    case decodingError(Error) // the error that took place when decoding
    case deletingError(Error)
}


class PersistenceHelper {
    
    // CRUD - create, read, update, delete
    
    // array of events
    private static var events = [Event]()
    
    private static let filename = "schedules.plist"
    
    private static func save() throws { // this function is used for save, delete, and update
        // 1. get url path to the file that item(e.g event) will be saved to
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        // 2. convert events array to Data object, which can be saved/ write to documents
        do {
            // convert (serialize) the events array to Data
            let data = try PropertyListEncoder().encode(events) // convert to Data (bytes)
            
            // 3. write/save the data to the documents directory
            try data.write(to: url, options: .atomic)
        } catch {
            // 4. throw an error
            throw DataPersistenceError.savingError(error)
        }
    }
    
    // create - save item to documents directory
    static func save(event: Event) throws { // make this function a throwing function by marking it with throws
        events.append(event)
        do {
            try save()
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    // read - load/retrieve items from documents directory
    static func loadEVents() throws -> [Event] {
        // to access the events, you need to access the directory where they are stored
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        // check if file exists at the url
        // to convert url to string use .path() on the url
        if FileManager.default.fileExists(atPath: url.path()) { // if there is a file at the url, proceed to line 54
            if let data = FileManager.default.contents(atPath: url.path()) {
                do {
                    events = try PropertyListDecoder().decode([Event].self, from: data)
                } catch {
                    throw DataPersistenceError.decodingError(error)
                }
            } else {
                throw DataPersistenceError.noData
            }
        } else {
            throw DataPersistenceError.fileDoesNotExist(filename)
        }
        return events
    }
    
    // update
    
    
    // delete - remove item from documents directory
    static func delete(event index: Int) throws {
        // remove the item from the events array
        events.remove(at: index)
        
        // save our events array to the documents directory
        do {
            try save()
        } catch {
            throw DataPersistenceError.deletingError(error)
        }
    }
}
