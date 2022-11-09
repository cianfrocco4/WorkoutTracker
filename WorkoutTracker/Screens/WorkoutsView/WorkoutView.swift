//
//  WorkoutView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/23/22.
//

import SwiftUI

struct WorkoutView: View {
    
    @StateObject var viewModel = WorkoutViewModel()

    @Binding var workout : Workout
    
    @EnvironmentObject var workoutObject : WorkoutObject
        
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
                                viewModel.isShowingExercise = true
                                guard let lnIndex = workout.exercises.firstIndex(where: {$0.id == exercise.id}) else { return }
                                viewModel.selectedExerciseIndex = lnIndex
                            } label: {
                                Text("\(exercise.name)")
                            }
                        }
                    }
                }
                .navigationTitle(workout.name)
            }
            .blur(radius: viewModel.isShowingExercise ? 30 : 0)
            .disabled(viewModel.isShowingExercise)
            
            if viewModel.isShowingExercise && viewModel.selectedExerciseIndex != -1 {
                ExerciseView(isShowingExercise: $viewModel.isShowingExercise,
                             exercise: $workout.exercises[viewModel.selectedExerciseIndex])
            }
        }
        .onAppear() {
            viewModel.getExercises(workout: &workout)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: .constant(WorkoutMockData.sampleWorkout1))
    }
}
