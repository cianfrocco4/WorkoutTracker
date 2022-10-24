//
//  Alert.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/23/22.
//


import SwiftUI

struct AlertItem : Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidForm = AlertItem(title: Text("Invalid Form"),
                                       message: Text("Make sure all fields are completed."),
                                       dismissButton: .default(Text("Ok")))
}
