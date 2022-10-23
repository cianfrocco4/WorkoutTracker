//
//  NewWorkoutView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/22/22.
//

import SwiftUI

struct NewWorkoutView: View {
    @Binding var workout: Workout
    @Binding var isShowingNewWorkout: Bool
    
    var body: some View {
        VStack {
            Form {
                Section (header: Text("Workout Information")) {
                    HStack {
                        Text("Workout Name:")
                        TextField("Workout Name", text: $workout.name)
                    }
                    
                    TextField("Workout Description", text: $workout.description)
                    TextField("Number of Sets", value: $workout.numSets, formatter: NumberFormatter())
                    TextField("Number of Reps Per Set", value: $workout.numReps, formatter: NumberFormatter())
                    TextField("Weight", value: $workout.weight, formatter: NumberFormatter())
                }
            }
            
            Button {
                isShowingNewWorkout = false
            } label: {
                Text("Save New Workout")
            }
        }
        .frame(width: 300, height: 525)
    }
}
//
//struct NewWorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
////        NewWorkoutView(workout: .constant(MockData.sampleWorkout1),
////                       isShowingNewWorkout: .constant(true))
//    }
//}
