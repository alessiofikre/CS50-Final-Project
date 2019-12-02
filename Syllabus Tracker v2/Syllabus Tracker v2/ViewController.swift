//
//  ViewController.swift
//  Syllabus Tracker v2
//
//  Created by Alessio Fikre on 11/27/19.
//  Copyright © 2019 Alessio Fikre. All rights reserved.
//  

import UIKit

class TableViewController: UITableViewController {
    var assignments: [Assignment] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
        // Do any additional setup after loading the view.

    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd HH:mm"
        
    }
    
    let classes = [
        (classNumber: 1, className: "AM104"),
        (classNumber: 2, className: "CS50"),
        (classNumber: 3, className: "Tech Ethics")
    ]
    
    let list = [
        (classAssignment: "Final Project", deadline: "12/8 11:59 PM"),
        (classAssignment: "Final Exam", deadline: "12/12 9:00 AM"),
        (classAssignment: "Final Exam", deadline: "12/15 3:00 PM"),
        ]
    
    func reload() {
        //assignments = AssignmentManager.shared.create(assignment: UserInput)
        tableView.reloadData()
     }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return assignments.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainAssignmentCell", for: indexPath)
        cell.textLabel?.text = assignments[indexPath.row].className + ": " + assignments[indexPath.row].assignmentName
        cell.detailTextLabel?.text = assignments[indexPath.row].dueDate
        return cell
        }
    
}
