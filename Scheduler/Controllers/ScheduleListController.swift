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
    
    var isEditingTableView = false {
        didSet {
            tableView.isEditing = isEditingTableView
            navigationItem.leftBarButtonItem?.title = isEditingTableView ? "Done" : "Edit"
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy, hh:mm a"
        formatter.timeZone = .current
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // events = Event.getTestData().sorted { $0.date > $1.date }
        tableView.dataSource = self
        loadEvents()
        
        // print path to documents directory
        print(FileManager.getDocumentsDirectory())
    }
    
    private func loadEvents() {
        do {
            events = try PersistenceHelper.loadEVents()
        } catch {
            print("Error loading events: \(error)")
        }
    }
    
    @IBAction func addNewEvent(segue: UIStoryboardSegue) {
        guard let createEventVC = segue.source as? CreateEventController, let createdEvent = createEventVC.event else { fatalError("Could not access CreateEvent View Controller") }
        
        // persist event to documents directory
        do {
            try PersistenceHelper.save(event: createdEvent)
        } catch {
            print("Error saving event: \(error)")
        }
        
        // 1. update the data model e.g update the events array
        events.insert(createdEvent, at: 0) // 0 is at the top of the event array
        
        // created indexPath to be inserted into the table view. This is used to be able to reorder the rows as they will have an assigned index
        let indexPath = IndexPath(row: 0, section: 0) // this constant will represent top of the table view
        
        // 2. we need to update the table view
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        isEditingTableView.toggle()
    }
    
    private func deleteEvent(indexPath: IndexPath) {
        do {
            try PersistenceHelper.delete(event: indexPath.row)
        } catch {
            print("Error deleting event \(error)")
        }
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
        cellContent.secondaryText = dateFormatter.string(from: event.date)
        cell.contentConfiguration = cellContent
        return cell
    }
    
    // MARK:- deleting rows
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .insert:
            // only gets called if "insertion control" exists and gets selected 
            print("Insert")
        case .delete:
            print("deleting...")
            // remove item from the data model
            events.remove(at: indexPath.row)
            // update the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteEvent(indexPath: indexPath)
        default:
            print("....")
        }
    }
    
    // MARK:- reordering rows in table view
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let eventToMove = events[sourceIndexPath.row] // 1. save the event being moved to a new array; event being moved is stored in sourceIndexPath.
        events.remove(at: sourceIndexPath.row) // 2. remove it from the events array data
        events.insert(eventToMove, at: destinationIndexPath.row) // 3. insert it back into events array with its new indexPath
    }
}

