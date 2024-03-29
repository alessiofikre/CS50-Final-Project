//
//  NewAssignmentViewController.swift
//  Syllabus Tracker v2
//
//  Created by Christopher O'Brien on 11/30/19.
//  Copyright © 2019 Alessio Fikre. All rights reserved.
//

import Foundation
import UIKit

class NewAssignmentViewController: UIViewController, UITextFieldDelegate{
    
    @IBAction func updateAssignment(_ sender: Any) {
        var userInput = Assignment(id: 1, className: "hello" , assignmentName: "hello1", weight: "hello2" , dueDate: "hello3", startDate: "hello4")
        print("This line is running")
        //New function to set user input
               userInput.className! = String(classField.text!)
               userInput.assignmentName! = String(assignmentField.text!)
               userInput.weight = String(weightField.text!)
               userInput.dueDate = String(dueDateField.text!)
               userInput.startDate = String(startDateField.text!)
        print("\(String(classField.text!))")
        print("\(String(userInput.className!))")
        
        let _ = AssignmentManager.shared.create(userInput: userInput)
        //TableViewController.reload()
        //let _ = AssignmentManager.shared.update(assignment: assignment!)
        print("beforepop")
        
        navigationController?.popViewController(animated: true)
        
        print("afterpop")
        
    }

    //Wired up IBOutlets for the input fields
    @IBOutlet var classField: UITextField!
    @IBOutlet var assignmentField: UITextField!
    @IBOutlet var weightField: UITextField!
    @IBOutlet var dueDateField: UITextField!
    @IBOutlet var startDateField: UITextField!
    
    //Wired up IBOutlet for the display field
    @IBOutlet var textView: UITextView!
    
    //Creating the date pickers for start and due dates
    private var dueDatePicker: UIDatePicker?
    private var startDatePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegating all of the input text fields
        self.classField?.delegate = self as UITextFieldDelegate
        self.assignmentField?.delegate = self as UITextFieldDelegate
        self.weightField?.delegate = self as UITextFieldDelegate
        self.dueDateField?.delegate = self as UITextFieldDelegate
        self.startDateField?.delegate = self as UITextFieldDelegate
        
        //Setting up the due date picker
        dueDatePicker = UIDatePicker()
       dueDatePicker?.datePickerMode = .dateAndTime
        dueDatePicker?.addTarget(self, action: #selector(NewAssignmentViewController.dueDateChanged(dueDatePicker:)), for: .valueChanged)
        //Allows for the due date field to be a date picker
        dueDateField.inputView = dueDatePicker
        
        
        //setting up the start date picker
       startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .dateAndTime
         startDatePicker?.addTarget(self, action: #selector(NewAssignmentViewController.startDateChanged(startDatePicker:)), for: .valueChanged)
         //Allows for a start date field to be a date picker
        startDateField.inputView = startDatePicker
        
        
        //Enabling for tapping whitespace to dismiss the keyboards
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewAssignmentViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    //function for tapping whitespace
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    //function for formatting due date
    @objc func dueDateChanged(dueDatePicker: UIDatePicker){
        //Formats the date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        //Display the date and time
        dueDateField.text = dateFormatter.string(from: dueDatePicker.date)
    }
    
    //Function for formatting start date
    @objc func startDateChanged(startDatePicker: UIDatePicker){
        //Formats the date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        //Display the date and time
        startDateField.text = dateFormatter.string(from: startDatePicker.date)
    }
    
    //allows for hitting the done button to stop entering text into the fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Action Will display all of the information that the user inputted
    @IBAction func enterTapped(_ sender: Any) {
        textView.text = "Class: \(classField.text!)\nAssignment: \(assignmentField.text!)\nWeight: \(weightField.text!)\nDue Date: \(dueDateField.text!)\nStart Date: \(startDateField.text!)"
        
        
    }
    
    
    
}

