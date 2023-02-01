//
//  CreateEventViewController.swift
//  Scheduler
//
//  Created by Brendon Crowe on 12/27/22.
//

import UIKit

class CreateEventController: UIViewController {
    
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var eventTime: UIDatePicker!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTextField.delegate = self
        event = Event(name: "No event", date: Date())
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        event?.date = sender.date
    }
    
    @IBAction func createEventButtonTapped(_ sender: UIButton) {
        event?.name = eventTextField.text ?? "Nothing was typed"
    }
}

extension CreateEventController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
