//
//  FileManager+Extensions.swift
//  Scheduler
//
//  Created by Brendon Crowe on 1/31/23.
//

import Foundation

extension FileManager {
    
    // function gets URL path to documents directory
    // documents/
    static func getDocumentsDirectory() -> URL {
        // get the url === for: file directory that you want, in: location of the file directory
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // The next important thing to do is create a file and append it to documentDirectory in order to read and write
    // documents/schedules.plist
    static func pathToDocumentsDirectory(with filename: String) -> URL {
        return getDocumentsDirectory().appending(path: filename)
    }
}
