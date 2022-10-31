//
//  WorkoutsView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/18/22.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject var viewModel = WorkoutsViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.workouts) { workout in
                        Button {
                            viewModel.isShowingWorkout = true
                            guard viewModel.workouts.firstIndex(where: {$0.id == workout.id}) != nil else { return }
                            viewModel.selectedWorkoutIndex = viewModel.workouts.firstIndex(where: {$0.id == workout.id})!
                        } label: {
                            Text(workout.name)
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        .multilineTextAlignment(.leading)
                        .padding()
                    }
                    .onDelete { (indexSet) in
                        viewModel.workouts.remove(atOffsets: indexSet)
                    }
                    
                    Button {
                        viewModel.isShowingNewWorkout = true
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
            .blur(radius: viewModel.isShowingNewWorkout ? 30 : 0)
            .disabled(viewModel.isShowingNewWorkout)
            
            if viewModel.isShowingNewWorkout {
                NewWorkoutView(workouts: $viewModel.workouts,
                               isShowingNewWorkout: $viewModel.isShowingNewWorkout)
            }
            else if viewModel.isShowingWorkout && viewModel.selectedWorkoutIndex != -1 {
                WorkoutView(workout: $viewModel.workouts[viewModel.selectedWorkoutIndex])
            }
        }
        .onAppear() {
            viewModel.getWorkouts()
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
