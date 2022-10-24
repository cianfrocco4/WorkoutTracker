//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/18/22.
//

import Foundation

// This struct contains the information that an exercise has
struct Exercise: Decodable, Identifiable {
    var id = -1
    var name: String = ""
    var description: String = ""
    var numSets: Int = 0
    var numReps: Int = 0
    var weight: Int = 0
}

// This struct contains the data for each individual completed exercise
struct ExerciseData: Decodable, Identifiable {
    var id : Int
    var date : Date
    var exercise : Exercise
    var repArray : [Int]
    var weightArray : [Int]
    var notes : String
}

struct MockData {
    static let sampleWorkout1 = Exercise(id: 0001,
                                        name: "Pullups",
                                        description: "This is the description for my workout.",
                                        numSets: 3,
                                        numReps: 10,
                                        weight: 10)
    
    static let sampleWorkout2 = Exercise(id: 0002,
                                        name: "Lat Pulldown",
                                        description: "This is the description for my workout.",
                                        numSets: 3,
                                        numReps: 10,
                                        weight: 10)
    
    static let sampleWorkout3 = Exercise(id: 0003,
                                        name: "Machine Bicep Curls",
                                        description: "This is the description for my workout.",
                                        numSets: 3,
                                        numReps: 10,
                                        weight: 10)
    
    static let sampleWorkouts = [sampleWorkout1, sampleWorkout2, sampleWorkout3]
    
    static let sampleExerciseData = ExerciseData(id: -1,
                                                 date: Date.now,
                                                 exercise: sampleWorkout1,
                                                 repArray: [10, 9, 8],
                                                 weightArray: [100, 100, 100],
                                                 notes: "Good weight")
    
//    static let sampleWorkouts : [Exercise] = []
    
}
