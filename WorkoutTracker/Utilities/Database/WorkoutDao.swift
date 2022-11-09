//
//  WorkoutDao.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 11/4/22.
//

import Foundation
import SQLite3

final class WorkoutDao {
    private let DB_NAME = "WorkoutTracker.sqlite"
    
    private var mcDatabase : OpaquePointer?
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    init() {
        openDatabase()
        setupDatabase()
    }
    
    deinit {
        closeDatabase()
    }
    
    func openDatabase() -> Void {
        
        // Get the sqlite db file or create it if it doesn't exist
        let lcFileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(DB_NAME)

        // open database

        guard sqlite3_open(lcFileURL.path, &mcDatabase) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(mcDatabase)
            return
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        print("Susccessfully opened database: WorkoutTracker.sqlite in: " + paths[0])
    }
    
    func insertWorkout(asNewWorkout: Workout) -> Void {
        if sqlite3_exec(mcDatabase, "INSERT INTO Workout (name, description) VALUES (\'" + asNewWorkout.name + "\', \'" + asNewWorkout.description + "\')", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    func setupDatabase() -> Void {
        
        if false {
            if sqlite3_exec(mcDatabase, "DROP TABLE IF EXISTS Workout", nil, nil, nil) != SQLITE_OK {
                print("Failed to drpo table Workout")
            }
            else {
                print("Dropped Workout table")
            }
        }
        
        if mcDatabase != nil {
            // create the workout table
            if sqlite3_exec(mcDatabase, "CREATE TABLE IF NOT EXISTS Workout (id integer primary key autoincrement, name text, description text)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
                print("error creating table: \(errmsg)")
            }
        }
    }
    
    func selectWorkouts() -> [Workout] {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(mcDatabase, "SELECT id, name, description FROM Workout", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error preparing select: \(errmsg)")
        }

        var lasWorkouts : [Workout] = []
        while sqlite3_step(statement) == SQLITE_ROW {

            var workout = Workout()

            let id = sqlite3_column_int64(statement, 0)
            if id >= 0 {
                workout.id = Int(id)
                
                if let cString = sqlite3_column_text(statement, 1) {
                    let name = String(cString: cString)
                    print("name = \(name)")
                    
                    workout.name = name
                                        
                    if let cString = sqlite3_column_text(statement, 2) {
                        let description = String(cString: cString)
                        print("description = \(name)")
                        
                        workout.description = description
                        
                        lasWorkouts.append(workout)
                                        
                    } else {
                        print("Workout description not found")
                    }
                                    
                } else {
                    print("Workout name not found")
                }
            }
            else {
                print("Workout ID not valid: " + String(id))
            }
        }

        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error finalizing prepared statement: \(errmsg)")
        }

        statement = nil
        
        return lasWorkouts
    }
    
    func closeDatabase() -> Void {
        if sqlite3_close(mcDatabase) != SQLITE_OK {
            print("error closing database")
        }
    }
}
