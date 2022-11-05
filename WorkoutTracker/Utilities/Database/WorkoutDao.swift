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
        
        print("Susccessfully opened database: WorkoutTracker.sqlite")
    }
    
    func insertWorkout(asNewWorkout: Workout) -> Void {
        if sqlite3_exec(mcDatabase, "INSERT INTO Workout (name, description) VALUES (\'" + asNewWorkout.name + "\', \'" + asNewWorkout.description + "\')", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    func setupDatabase() -> Void {
        
        if mcDatabase != nil {
            // create the workout table
            if sqlite3_exec(mcDatabase, "CREATE TABLE IF NOT EXISTS Workout (id integer primary key autoincrement, name text, description text)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
                print("error creating table: \(errmsg)")
            }
            
            // create the exercise table
            if sqlite3_exec(mcDatabase, "CREATE TABLE IF NOT EXISTS Exercise (id integer primary key autoincrement, name text, description text)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
                print("error creating table: \(errmsg)")
            }
            
            // create the ExerciseToWorkout table
            if sqlite3_exec(mcDatabase, "CREATE TABLE IF NOT EXISTS ExerciseToWorkout (exerciseId integer, workoutId integer, PRIMARY KEY (exerciseId, workoutId))", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
                print("error creating table: \(errmsg)")
            }
        }
    }
    
    func selectWorkouts() -> [Workout] {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(mcDatabase, "SELECT name FROM Workout", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error preparing select: \(errmsg)")
        }

        var lasWorkouts : [Workout] = []
        while sqlite3_step(statement) == SQLITE_ROW {

            if let cString = sqlite3_column_text(statement, 0) {
                let name = String(cString: cString)
                print("name = \(name)")
                
                var workout = Workout()
                workout.name = name
                
                lasWorkouts.append(workout)
                
            } else {
                print("name not found")
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
