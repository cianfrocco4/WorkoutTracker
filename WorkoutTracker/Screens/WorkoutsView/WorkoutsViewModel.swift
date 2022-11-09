//
//  WorkoutsViewModel.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/30/22.
//

import SwiftUI
import SQLite3

let gcWorkoutDao = WorkoutDao()
let gcExerciseDao = ExerciseDao()

final class WorkoutsViewModel: ObservableObject {
    @Published var workouts : [Workout] = []
    @Published var isShowingNewWorkout = false
    @Published var isShowingWorkout = false
    @Published var selectedWorkoutIndex : Int = -1
    
    func getWorkouts() {
    
        var lasWorkouts = gcWorkoutDao.selectWorkouts()
        
        for lnWorkoutIndex in lasWorkouts.indices {
            let lasExercises = gcExerciseDao.selectExercisesForWorkoutId(workoutId: lasWorkouts[lnWorkoutIndex].id)
            
            for lsExercise in lasExercises {
                lasWorkouts[lnWorkoutIndex].exercises.append(lsExercise)
            }
            
            workouts.append(lasWorkouts[lnWorkoutIndex])
        }
    }
}
