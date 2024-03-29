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
    var className: String?
    var assignmentName: String?
    var weight: String?
    var dueDate: String?
    var startDate: String?
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
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("assignments.sqlite")
            
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
    func create(userInput: Assignment) -> Int {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO assignments (className, assignmentName, weight, dueDate, startDate) VALUES (?,?,?,?,?)",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: userInput.className ?? "Empty").utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, NSString(string: userInput.assignmentName ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, NSString(string: userInput.weight ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, NSString(string: userInput.dueDate ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, NSString(string: userInput.startDate ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_int(statement, 6, userInput.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting assignment")
            }
        }
        else {
            print("Error creating assignment insert statement")
        }
        
        sqlite3_finalize(statement)
        
        return Int(sqlite3_last_insert_rowid(database))
        
    }
    
    func getAssignments() -> [Assignment] {
        connect()
        
        var result: [Assignment] = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT rowid, className, assignmentName, weight, dueDate, startDate FROM assignments", -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                result.append(Assignment(
                    id: sqlite3_column_int(statement, 0),
                    className: String(cString: sqlite3_column_text(statement, 1))
                ))
            }
        }
        
        sqlite3_finalize(statement)
        return result
    }
    
    //Update new assingments
    func update(assignment: Assignment){
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            //Need to write this for assignments
            "UPDATE assignments SET className = ?, assignmentName = ?, weight = ?, dueDate = ?, startDate = ? WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: assignment.className ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, NSString(string: assignment.assignmentName ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, NSString(string: assignment.weight ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, NSString(string: assignment.dueDate ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, NSString(string: assignment.startDate ?? "Nothing").utf8String, -1, nil)
            sqlite3_bind_int(statement, 6, assignment.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error saving assignment")
            }
        }
        else {
            print("Error creating assignment update statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteAssignment(assignment: Assignment) {
    connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "DELETE FROM assignments WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, assignment.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error deleting assignment")
            }
        }
        
        sqlite3_finalize(statement)
        
    }
    
    
}
    
