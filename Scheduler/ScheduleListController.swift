//
//  ViewController.swift
//  Scheduler
//
//  Created by Brendon Crowe on 12/27/22.
//

import UIKit

class ScheduleListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // data - an array of events
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events = Event.getTestData()
        tableView.dataSource = self // DO NOT FORGET THE DATA SOURCE!!
    }
    
    
    @IBAction func addNewEvent(segue: UIStoryboardSegue) {
        guard let createEventVC = segue.source as? CreateEvent, let createdEvent = createEventVC.event else { fatalError("Could not access CreateEvent View Controller") }
        
        events.insert(createdEvent, at: 0) // 0 is at the top of the event array
        
        // created indexPath to be inserted into the table view
        let indexPath = IndexPath(row: 0, section: 0) // this constant will represent top of the table view
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
}

extension ScheduleListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let event = events[indexPath.row]
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = event.name
        cellContent.secondaryText = event.date.description
        cell.contentConfiguration = cellContent
        return cell
    }
    
    // MARK:- deleting rows
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .insert:
            print("Insert")
        case .delete:
            print("Delete")
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            print("....")
        }
    }
}

