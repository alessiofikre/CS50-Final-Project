//
//  NewAssignmentViewController.swift
//  Syllabus Tracker v2
//
//  Created by Christopher O'Brien on 11/30/19.
//  Copyright © 2019 Alessio Fikre. All rights reserved.
//

import Foundation
import UIKit

class NewAssingmentViewController: UIViewController{
    
    //IBOutlet
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
