//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/18/22.
//

import Foundation

struct Workout: Decodable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var numSets: Int
    var numReps: Int
    var weight: Int
}

struct MockData {
    static let sampleWorkout1 = Workout(id: 0001,
                                        name: "Push 1",
                                        description: "This is the description for my workout.",
                                        numSets: 3,
                                        numReps: 10,
                                        weight: 10)
    
    static let sampleWorkout2 = Workout(id: 0002,
                                        name: "Pull 1",
                                        description: "This is the description for my workout.",
                                        numSets: 3,
                                        numReps: 10,
                                        weight: 10)
    
    static let sampleWorkout3 = Workout(id: 0003,
                                        name: "Legs",
                                        description: "This is the description for my workout.",
                                        numSets: 3,
                                        numReps: 10,
                                        weight: 10)
    
//    static let sampleWorkouts = [sampleWorkout1, sampleWorkout2, sampleWorkout3]
    static let sampleWorkouts : [Workout] = []
    
}
