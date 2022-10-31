//
//  WorkoutsViewModel.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/30/22.
//

import SwiftUI
import SQLite3

final class WorkoutsViewModel: ObservableObject {
    @Published var workouts : [Workout] = []
    @Published var isShowingNewWorkout = false
    @Published var isShowingWorkout = false
    @Published var selectedWorkoutIndex : Int = -1
    
    func getWorkouts() {
        guard let db = openDatabase() else { return }
        
        setupDatabase(db: db)
        
        selectWorkouts(db: db)
        
        closeDatabase(db: db)
    }
    
    func openDatabase() -> OpaquePointer? {
        
        // Get the sqlite db file or create it if it doesn't exist
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent("WorkoutTracker.sqlite")

        // open database

        var db: OpaquePointer?
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            return nil
        }
        
        print("Susccessfully opened database: WorkoutTracker.sqlite")
        
        return db
    }
    
    func setupDatabase(db: OpaquePointer) -> Void {
        // create the workout table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Workout (id integer primary key autoincrement, name text, description text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        // create the exercise table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Exercise (id integer primary key autoincrement, name text, description text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        // create the ExerciseToWorkout table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS ExerciseToWorkout (exerciseId integer, workoutId integer, PRIMARY KEY (exerciseId, workoutId))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    func selectWorkouts(db: OpaquePointer) -> Void {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "SELECT name FROM Workout", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }

        while sqlite3_step(statement) == SQLITE_ROW {

            if let cString = sqlite3_column_text(statement, 0) {
                let name = String(cString: cString)
                print("name = \(name)")
                
                var workout = Workout()
                workout.name = name
                
                workouts.append(workout)
                
            } else {
                print("name not found")
            }
        }

        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }

        statement = nil
    }
    
    func closeDatabase(db: OpaquePointer) {
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
}
