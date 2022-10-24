//
//  WorkoutsView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/18/22.
//

import SwiftUI

struct WorkoutsView: View {
    @State private var workouts : [Workout] = []
    @State private var isShowingNewWorkout = false
    @State private var isShowingWorkout = false
    @State private var selectedWorkoutIndex : Int = -1
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(workouts) { workout in
                        Button {
                            isShowingWorkout = true
                            guard workouts.firstIndex(where: {$0.id == workout.id}) != nil else { return }
                            selectedWorkoutIndex = workouts.firstIndex(where: {$0.id == workout.id})!
                        } label: {
                            Text(workout.name)
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        .multilineTextAlignment(.leading)
                        .padding()
                    }
                    .onDelete { (indexSet) in
                        self.workouts.remove(atOffsets: indexSet)
                    }
                    
                    Button {
                        isShowingNewWorkout = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add New Workout")
                        }
                    }
                    .padding()
                }
                .navigationTitle("Workouts 💪")
                
            }
            .blur(radius: isShowingNewWorkout ? 30 : 0)
            .disabled(isShowingNewWorkout)
            
            if isShowingNewWorkout {
                NewWorkoutView(workouts: $workouts,
                               isShowingNewWorkout: $isShowingNewWorkout)
            }
            else if isShowingWorkout && selectedWorkoutIndex != -1 {
                WorkoutView(workout: $workouts[selectedWorkoutIndex])
            }
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
