//
//  ExerciseDao.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 11/4/22.
//

import Foundation
import SQLite3
import SwiftUI

final class ExerciseDao {
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
        
        guard let lcPath = FileManager.default.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory,
                                              in: FileManager.SearchPathDomainMask.userDomainMask).first
        else { return }
        
        print("Opening database at: " + lcPath.absoluteString)
        
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
    
    func insertExercise(asNewExercise: Exercise,
                        asWorkout: Workout) -> Void {
        // TODO workout does not have id set properly, is currently -1
        
        // Insert the new Exercise into the Exercise Table
        if sqlite3_exec(mcDatabase, "INSERT INTO Exercise (name, description, numSets, numReps, weight) VALUES (\'" + asNewExercise.name + "\', \'" + asNewExercise.description + "\', \'" + String(asNewExercise.numSets) + "\', \'" + String(asNewExercise.numReps) + "\', \'" + String(asNewExercise.weight) + "\')", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error creating table: \(errmsg)")
        }
        
        // Insert the mapping from Exercise to Workout
        if sqlite3_exec(mcDatabase, "INSERT INTO ExerciseToWorkout (exerciseId, workoutId) VALUES (\'" + String(asNewExercise.id) + "\', \'" + String(asWorkout.id) + "\')", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    func setupDatabase() -> Void {
        
        if mcDatabase != nil {
            
            if false {
                if(sqlite3_exec(mcDatabase, "drop table if exists Exercise", nil, nil, nil) != SQLITE_OK) {
                    print("Failed to drop Exercise table")
                }
                else {
                    print("Dropped Exercise table")
                }
            }
            
            if false {
                if(sqlite3_exec(mcDatabase, "drop table if exists ExerciseToWorkout", nil, nil, nil) != SQLITE_OK) {
                    print("Failed to drop ExerciseToWorkout table")
                }
                else {
                    print("Dropped ExerciseToWorkout table")
                }
            }
            
            // create the exercise table
            if sqlite3_exec(mcDatabase, "CREATE TABLE IF NOT EXISTS Exercise (id integer primary key autoincrement, name text, description text, numSets integer, numReps integer, weight double)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
                print("error creating table: \(errmsg)")
            }
            
            // create the ExerciseToWorkout table
            if sqlite3_exec(mcDatabase, "CREATE TABLE IF NOT EXISTS ExerciseToWorkout (exerciseId integer, workoutId integer, PRIMARY KEY (exerciseId, workoutId))", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
                print("error creating table: \(errmsg)")
            }
            
            // TODO Create Historical Exercise Table
        }
    }
    
    func selectExercises(acQuery : String) -> [Exercise] {
        var statement: OpaquePointer?
        
        print("Executing query: " + acQuery)
                
        if sqlite3_prepare_v2(mcDatabase, acQuery, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error preparing select: \(errmsg)")
        }

        var lasExercises : [Exercise] = []
        while sqlite3_step(statement) == SQLITE_ROW {

            let id = sqlite3_column_int64(statement, 0)
            if id >= 0 {
                var lsExercise = Exercise()
                lsExercise.id = Int(id)
                
                if let cString = sqlite3_column_text(statement, 1) {
                    let lcName = String(cString: cString)
                    print("name = \(lcName)")
                    
                    lsExercise.name = lcName
                    
                    if let cString = sqlite3_column_text(statement, 2) {
                        let lcDescription = String(cString: cString)
                        lsExercise.description = lcDescription
                        
                        let numSets = sqlite3_column_int(statement, 3)
                        let numReps = sqlite3_column_int(statement, 4)
                        let weight = sqlite3_column_int(statement, 5)
                        
                        if(numSets < 0 ||
                           numReps < 0 ||
                           weight < 0) {
                            lsExercise.numSets = Int(numSets)
                            lsExercise.numReps = Int(numReps)
                            lsExercise.weight = Int(weight)
                            
                            lasExercises.append(lsExercise)
                        }
                        else {
                            print("numSets or numReps or weight not found")
                        }
                    }
                    else {
                       print("description not found")
                    }
                } else {
                    print("name not found")
                }
            }
        }

        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(mcDatabase)!)
            print("error finalizing prepared statement: \(errmsg)")
        }

        statement = nil
        
        return lasExercises
    }
    
    func selectExercisesForWorkoutId(workoutId : Int) -> [Exercise] {
        
        let lcQuery = "SELECT id, name, description, numSets, numReps, weight" +
                      " FROM Exercise" +
                      " INNER JOIN ExerciseToWorkout on Exercise.id = ExerciseToWorkout.ExerciseId" +
                      " WHERE ExerciseToWorkout.workoutId = " + String(workoutId)
        
        return selectExercises(acQuery: lcQuery)
    }
    
    func closeDatabase() -> Void {
        if sqlite3_close(mcDatabase) != SQLITE_OK {
            print("error closing database")
        }
    }
}

