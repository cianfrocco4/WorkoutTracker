//
//  ExerciseView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/23/22.
//

import SwiftUI

struct ExerciseView: View {
    
    @Binding var isShowingExercise : Bool
    @Binding var exercise : Exercise
    
    @State private var data : ExerciseData = EmptyExerciseData
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack {
                        if data.repArray.count == exercise.numSets &&
                            data.weightArray.count == exercise.numSets {
                            ForEach(0..<exercise.numSets, id: \.self) { setNum in
                                Section (header: Text("Set \(setNum)")) {
                                    Stepper("Number of Reps = \(data.repArray[setNum])",
                                            value: $data.repArray[setNum], in: 0...Int.max)
                                }
                            }
                        }
                        else {
                            Text("Invalid Exercise")
                        }
                    }
                }
            }
            .navigationTitle("\(exercise.name)")
        }
        .frame(width: 300, height: 375)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(alignment: .topTrailing) {
            Button {
                isShowingExercise = false
            } label: {
                XDismissButton()
            }
        }
        .onAppear() {
            for _ in 0..<exercise.numSets {
                data.repArray.append(exercise.numReps)
                data.weightArray.append(exercise.weight)
            }
            
            data.id = exercise.id // TODO change to correctly set the id
            data.date = Date.now
            data.exercise = exercise
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(isShowingExercise: .constant(false),
                     exercise: .constant(MockData.sampleWorkout1))
    }
}

let EmptyExerciseData : ExerciseData = ExerciseData(id: -1,
                                            date: Date.now,
                                            exercise: Exercise(),
                                            repArray: [],
                                            weightArray: [],
                                            notes: "")
