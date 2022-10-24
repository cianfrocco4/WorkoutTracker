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

    @State private var alertItem : AlertItem?
    @State private var exercises : [Exercise] = []
    @State private var isShowingNewExercise : Bool = false
    @State private var newWorkout = Workout()
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    Section (header: Text("Workout Information")){
                        TextField("Workout Name", text: $newWorkout.name)
                        TextField("Workout Description", text: $newWorkout.description)
                        
                        List {
                            ForEach(exercises) { exercise in
                                Button {
                                    print("Exercise button pressed")
                                } label: {
                                    AppButtonLabel(title: LocalizedStringKey(stringLiteral: exercise.name))
                                }
                            }
                            .onDelete { (indexSet) in
                                self.exercises.remove(atOffsets: indexSet)
                            }
                            
                            Button {
                                isShowingNewExercise = true
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
                .blur(radius: isShowingNewExercise ? 30 : 0)
                .disabled(isShowingNewExercise)
                
                Spacer()
                
                Button {
                    print("Pressed save exercise button")
                    
                    if newWorkout.name != "" && !exercises.isEmpty {
                        newWorkout.exercises = exercises
                        workouts.append(newWorkout)
                        isShowingNewWorkout = false
                    }
                    else {
                        alertItem = AlertContext.invalidForm
                    }
                } label: {
                    AppButtonLabel(title: "Save new workout")
                }
            }
            
            if isShowingNewExercise {
                NewExerciseView(exercises: $exercises,
                                isShowingNewExercise: $isShowingNewExercise)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                isShowingNewWorkout = false
            } label: {
                XDismissButton()
            }
        }
        .alert(item: $alertItem) { alertItem in
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
