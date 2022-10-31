//
//  NewWorkoutViewModel.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/30/22.
//

import SwiftUI
import SQLite3

internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

final class NewWorkoutViewModel: ObservableObject {
    @Published var alertItem : AlertItem?
    @Published var exercises : [Exercise] = []
    @Published var isShowingNewExercise : Bool = false
    @Published var newWorkout = Workout()
    
    func addWorkout() {
        
        guard let db = openDatabase() else { return }
        
        insertWorkout(db: db)
        
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
    
    func insertWorkout(db: OpaquePointer) {
        if newWorkout.description == "" {
            newWorkout.description = "No Description."
        }
        
        if sqlite3_exec(db, "INSERT INTO Workout (name, description) VALUES (\'" + newWorkout.name + "\', \'" + newWorkout.description + "\')", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    func closeDatabase(db: OpaquePointer) {
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
}
