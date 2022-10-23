//
//  HomeView.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/17/22.
//

import SwiftUI

struct WorkoutTrackerTabView: View {
    var body: some View {
        TabView {
            WorkoutsView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Workouts")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTrackerTabView()
    }
}
