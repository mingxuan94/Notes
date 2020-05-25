//
//  Note.swift
//  Notes
//
//  Created by Ming Xuan on 24/5/20.
//  Copyright © 2020 MX. All rights reserved.
//


// Model file
import Foundation
import SQLite3

struct Note {
    let id: Int
    var content: String
}

// Handle creating the database, etc...
// Database will be stored on user's phone
class NoteManager  {
    
    // Address of database
    var database: OpaquePointer!
    
    // Single, to ensure that we do not have multiple NoteManagers
    static let main = NoteManager()
    private init() {
        
    }
    
    // Create connection to the database
    func connect() {
        
        // If database is already connected, do not connect again and again
        if database != nil {
            return
        }

        do {
            // Get the path to the db. Create database if it doesn't exist
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            
            // Go to address of the database and open connection
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                // Create table if it doesn't exists
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS NOTES (contents TEXT)", nil, nil,nil) == SQLITE_OK {
                }
                    // If query could not be executed
                else {
                    print("Could not connect")
                }
                
            }
                // If connection could not be executed
            else {
                print("Could not connect")
            }
        }
        catch {
            print("\(error)")
        }
        
    }
    
    // Create new note, insert details into the TABLE notes
    // Returns the ID of the new note created
    func create() -> Int {
        connect()
        
        // Pointer to our database file to keep the same connection to the database
        var statement: OpaquePointer!
        
        // Prepare SQL query
        if sqlite3_prepare_v2(database, "INSERT INTO notes (contents) VALUES ('')", -1, &statement, nil) != SQLITE_OK {
            print("Cuuld not create query")
            return -1
        }
        
        // Run SQL query
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not insert note")
            return -1
        }
        
        // Finish executing query
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    // Function to get all notes, basically a select * query
    // To update TableView
    // Returns a list of notes, ID | Content
    func getAllNotes() -> [Note] {
        connect()
        var result: [Note] = []
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "SELECT rowid, contents FROM notes", -1, &statement, nil) != SQLITE_OK {
            print("Error creating select")
            return []
        }
        
        // While loop - We want to run each step of the query for each row
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Note(id: Int(sqlite3_column_int(statement, 0)), content: String(cString: sqlite3_column_text(statement,1))))
        }
        sqlite3_finalize(statement)
        return result
    }
    
    // Function to save Note
    func save(note: Note) {
        connect()
        var statement: OpaquePointer!
        
        // ? are placeholders
        if sqlite3_prepare_v2(database, "UPDATE notes SET contents = ? WHERE rowid = ?", -1, &statement,nil) != SQLITE_OK {
            print("Error Update")
        }
        
        // Update placeholders here, make sure to update according to the sequence 
        sqlite3_bind_text(statement, 1, NSString(string: note.content).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error running update")
        }
        
        sqlite3_finalize(statement)
    }
    
    // Function to delete Note
    func delete(note: Note) {
        connect()
        
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "DELETE FROM notes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error delete")
        }
        
        // Update placeholder here
        sqlite3_bind_int(statement, 1, Int32(note.id))
        
        // Execute
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error running delete")
        }
        
        sqlite3_finalize(statement)
    }
}
