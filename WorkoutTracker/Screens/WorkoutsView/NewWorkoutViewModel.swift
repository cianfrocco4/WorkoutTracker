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

        if newWorkout.description == "" {
            newWorkout.description = "No Description."
        }
        
        let lcDao = WorkoutDao()
        lcDao.insertWorkout(asNewWorkout: newWorkout)
    }
}
