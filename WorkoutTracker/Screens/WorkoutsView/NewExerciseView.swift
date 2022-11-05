//
//  NewExerciseView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/22/22.
//

import SwiftUI

struct NewExerciseView: View {
    @Binding var exercises: [Exercise]
    @Binding var isShowingNewExercise: Bool
    
    @StateObject var viewModel = NewExerciseViewModel()
    
    var body: some View {
        VStack {
            Form {
                Section (header: Text("Exercise Information")) {
                    ExerciseFieldString(field: $viewModel.newExercise.name,
                                        fieldName: "Exercise Name")
                    ExerciseFieldString(field: $viewModel.newExercise.description,
                                        fieldName: "Exercise Description")
                    
                    Stepper("Number of Sets = \(viewModel.newExercise.numSets)",
                            value: $viewModel.newExercise.numSets, in: 0...Int.max)
                    Stepper("Number of Reps = \(viewModel.newExercise.numReps)",
                            value: $viewModel.newExercise.numReps, in: 0...Int.max)

                    HStack {
                        Text("Weight = ")
                        TextField("Weight",
                                  value: $viewModel.newExercise.weight,
                                  formatter: NumberFormatter())
                    }
                }
            }
            
            Button {
                if viewModel.newExercise.name != "" {
                    if exercises.isEmpty {
                        viewModel.newExercise.id = 0
                    }
                    else {
                        viewModel.newExercise.id = exercises.last!.id + 1
                    }
                    
                    exercises.append(viewModel.newExercise)
                    isShowingNewExercise = false
                }
                else {
                    viewModel.alertItem = AlertContext.invalidForm
                }
            } label: {
                AppButtonLabel(title: "Save new exercise")
                    .padding()
            }
        }
        .frame(width: 300, height: 375)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(alignment: .topTrailing) {
            Button {
                isShowingNewExercise = false
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

struct NewExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NewExerciseView(exercises: .constant(MockData.sampleWorkouts),
                        isShowingNewExercise: .constant(true))
    }
}

struct ExerciseFieldString : View {
    @Binding var field : String
    let fieldName : String
    
    var body: some View {
        HStack {
//            Text(fieldName + ":")
            TextField(fieldName, text: $field)
        }
    }
}
