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
        
        let lcDao = WorkoutDao()
        let lasWorkouts = lcDao.selectWorkouts()
        
        for lsWorkout in lasWorkouts {
            workouts.append(lsWorkout)
        }
    }
}
