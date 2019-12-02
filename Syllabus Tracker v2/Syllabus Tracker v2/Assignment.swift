//
//  Assignment.swift
//  Syllabus Tracker v2
//
//  Created by Christopher O'Brien on 12/1/19.
//  Copyright © 2019 Alessio Fikre. All rights reserved.
//

import Foundation
import SQLite3

struct Assignment {
    var id: Int32
    var className: String
    var assignmentName: String
    var weight: String
    var dueDate: String
    var startDate: String
}

class AssignmentManager {
    var database: OpaquePointer!
    
    static let shared = AssignmentManager()
    
    private init() {
       }
    
    func connect(){
        if database != nil {
            return
        }
            let databaseURL = try! FileManager.default.url(
                for: .userDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("assignments.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("Error opening database")
                return
            }
           
            if sqlite3_exec(
                database,
                """
 CREATE TABLE IF NOT EXISTS assignments (className TEXT, assignmentName TEXT, weight TEXT, dueDate TEXT, startDate TEXT)
""",
                nil,
                nil,
                nil
                   ) != SQLITE_OK {
                       print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
                   }
        }
    
    //Add creation function
    func create() -> Int {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO assignments (className, assignmentName, weight, dueDate, startDate) VALUES ( , , , , )",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting note")
            }
        }
        else {
            print("Error creating note insert statement")
        }
        
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    
    //Update new assingments
    func update(assignment: Assignment){
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            //Need to write this for assignments
            "UPDATE notes SET className = ?, assignmentName = ?, weight = ?, dueDate = ?, startDate = ? WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: assignment.className).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, NSString(string: assignment.assignmentName).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, NSString(string: assignment.weight).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, NSString(string: assignment.dueDate).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, NSString(string: assignment.startDate).utf8String, -1, nil)
            sqlite3_bind_int(statement, 6, assignment.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error saving note")
            }
        }
        else {
            print("Error creating note update statement")
        }
        
        sqlite3_finalize(statement)
    }
    
}
    

