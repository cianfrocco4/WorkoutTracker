//
//  WorkoutViewModel.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 11/4/22.
//

import SwiftUI

var gcDao = ExerciseDao()

final class WorkoutViewModel: ObservableObject {
    @Published var isShowingExercise = false
    @Published var selectedExerciseIndex = -1
    
    func getExercises(workout : inout Workout) -> Void {
        
        for lsExercise in gcDao.selectExercisesForWorkoutId(workoutId: workout.id) {
            workout.exercises.append(lsExercise)
        }
    }
}
