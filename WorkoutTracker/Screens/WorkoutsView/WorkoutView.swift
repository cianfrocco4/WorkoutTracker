//
//  WorkoutView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/23/22.
//

import SwiftUI

struct WorkoutView: View {
    
    @Binding var workout : Workout
    
    @State private var isShowingExercise = false
    @State private var selectedExerciseIndex = -1
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Text("\(workout.description)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    List {
                        ForEach (workout.exercises) { exercise in
                            Button {
                                print("Exercise pressed")
                                isShowingExercise = true
                                guard let lnIndex = workout.exercises.firstIndex(where: {$0.id == exercise.id}) else { return }
                                selectedExerciseIndex = lnIndex
                            } label: {
                                Text("\(exercise.name)")
                            }
                        }
                    }
                }
                .navigationTitle(workout.name)
            }
            .blur(radius: isShowingExercise ? 30 : 0)
            .disabled(isShowingExercise)
            
            if isShowingExercise && selectedExerciseIndex != -1 {
                ExerciseView(isShowingExercise: $isShowingExercise,
                             exercise: $workout.exercises[selectedExerciseIndex])
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: .constant(WorkoutMockData.sampleWorkout1))
    }
}
