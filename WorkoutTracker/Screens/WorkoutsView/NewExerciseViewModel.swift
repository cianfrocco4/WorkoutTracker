//
//  NewExerciseViewModel.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 11/4/22.
//

import SwiftUI

final class NewExerciseViewModel: ObservableObject {
    @Published var alertItem : AlertItem?
    @Published var newExercise: Exercise = Exercise()
    
    func addExercise(id : Int,
                     workout : Workout) -> Bool {
        var lbValid = true
        
        if newExercise.name != "" {
            newExercise.id = id
            
            let lcDao = ExerciseDao()
            lcDao.insertExercise(asNewExercise: newExercise,
                                 asWorkout: workout)
        }
        else {
            alertItem = AlertContext.invalidForm
            lbValid = false
        }
        
        return lbValid
    }
}
