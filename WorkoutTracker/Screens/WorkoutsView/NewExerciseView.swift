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
    
    @State private var alertItem : AlertItem?
    
    @State private var newExercise: Exercise = Exercise()
    
    var body: some View {
        VStack {
            Form {
                Section (header: Text("Exercise Information")) {
                    ExerciseFieldString(field: $newExercise.name,
                                        fieldName: "Exercise Name")
                    ExerciseFieldString(field: $newExercise.description,
                                        fieldName: "Exercise Description")
                    
                    Stepper("Number of Sets = \(newExercise.numSets)",
                            value: $newExercise.numSets, in: 0...Int.max)
                    Stepper("Number of Reps = \(newExercise.numReps)",
                            value: $newExercise.numReps, in: 0...Int.max)

                    HStack {
                        Text("Weight = ")
                        TextField("Weight",
                                  value: $newExercise.weight,
                                  formatter: NumberFormatter())
                    }
                }
            }
            
            Button {
                if newExercise.name != "" {
                    if exercises.isEmpty {
                        newExercise.id = 0
                    }
                    else {
                        newExercise.id = exercises.last!.id + 1
                    }
                    
                    exercises.append(newExercise)
                    isShowingNewExercise = false
                }
                else {
                    alertItem = AlertContext.invalidForm
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
        .alert(item: $alertItem) { alertItem in
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
