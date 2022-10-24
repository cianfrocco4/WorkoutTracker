//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/23/22.
//

import Foundation

struct Workout: Decodable, Identifiable {
    var id = -1
    var name: String = ""
    var description: String = ""
    var exercises: [Exercise] = []
}

struct WorkoutMockData {
    static let sampleWorkout1 = Workout(id: 0001,
                                        name: "Push 1",
                                        description: "This is the description for my workout.",
                                        exercises: MockData.sampleWorkouts)
    
    static let sampleWorkout2 = Workout(id: 0002,
                                        name: "Pull 1",
                                        description: "This is the description for my workout.",
                                        exercises: MockData.sampleWorkouts)
    
    static let sampleWorkout3 = Workout(id: 0003,
                                        name: "Legs",
                                        description: "This is the description for my workout.",
                                        exercises: MockData.sampleWorkouts)
    
//    static let sampleWorkouts = [sampleWorkout1, sampleWorkout2, sampleWorkout3]
    static let sampleWorkouts : [Workout] = []
    
}
