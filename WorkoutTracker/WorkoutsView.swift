//
//  WorkoutsView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/18/22.
//

import SwiftUI

struct WorkoutsView: View {
    @State private var workouts : [Workout] = MockData.sampleWorkouts
    @State private var isShowingNewWorkout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(workouts) { workout in
                        Button {
                            print("Workout button pressed")
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
                    .blur(radius: isShowingNewWorkout ? 20 : 0)
                    .disabled(isShowingNewWorkout)
                    
                    Button {
                        workouts.append(MockData.sampleWorkout1)
                        isShowingNewWorkout = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add New Workout")
                        }
                    }
                    .padding()
                }
                
                if isShowingNewWorkout {
                    NewWorkoutView(workout: $workouts.last!,
                                   isShowingNewWorkout: $isShowingNewWorkout)
                }
            }
            .navigationTitle("Workouts 💪")
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
