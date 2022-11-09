//
//  NewWorkoutView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/23/22.
//

import SwiftUI

struct NewWorkoutView: View {
    @Binding var workouts : [Workout]
    @Binding var isShowingNewWorkout: Bool
    
    @StateObject var viewModel = NewWorkoutViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    Section (header: Text("Workout Information")){
                        TextField("Workout Name", text: $viewModel.newWorkout.name)
                        TextField("Workout Description", text: $viewModel.newWorkout.description)
                        
                        List {
                            ForEach(viewModel.exercises) { exercise in
                                Button {
                                    print("Exercise button pressed")
                                } label: {
                                    AppButtonLabel(title: LocalizedStringKey(stringLiteral: exercise.name))
                                }
                            }
                            .onDelete { (indexSet) in
                                viewModel.exercises.remove(atOffsets: indexSet)
                            }
                            
                            Button {
                                viewModel.isShowingNewExercise = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add New Exercise")
                                }
                            }
                            .padding()
                        }
                    }
                }
                .blur(radius: viewModel.isShowingNewExercise ? 30 : 0)
                .disabled(viewModel.isShowingNewExercise)
                
                Spacer()
                
                Button {
                    print("Pressed save exercise button")
                    
                    if viewModel.newWorkout.name != "" && !viewModel.exercises.isEmpty {
                        
                        viewModel.addWorkout()
                        viewModel.newWorkout.exercises = viewModel.exercises
                        workouts.append(viewModel.newWorkout)
                        isShowingNewWorkout = false
                    }
                    else {
                        viewModel.alertItem = AlertContext.invalidForm
                    }
                } label: {
                    AppButtonLabel(title: "Save new workout")
                }
            }
            
            if viewModel.isShowingNewExercise {
                NewExerciseView(exercises: $viewModel.exercises,
                                isShowingNewExercise: $viewModel.isShowingNewExercise,
                                workout: viewModel.newWorkout)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                isShowingNewWorkout = false
            } label: {
                XDismissButton()
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

struct NewWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutView(workouts: .constant(WorkoutMockData.sampleWorkouts),
                       isShowingNewWorkout: .constant(false))
    }
}
