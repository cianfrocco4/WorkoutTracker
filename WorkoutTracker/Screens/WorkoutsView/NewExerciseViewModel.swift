//
//  NewExerciseViewModel.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 11/4/22.
//

import SwiftUI
import SQLite3

//internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
//internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

final class NewExerciseViewModel: ObservableObject {
    @Published var alertItem : AlertItem?
    @Published var newExercise: Exercise = Exercise()
}
