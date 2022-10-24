//
//  AppButton.swift
//  WorkoutTracker
//
//  Created by Anthony Cianfrocco on 10/23/22.
//

import SwiftUI

struct AppButtonLabel: View {
    let title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 260, height: 50)
            .foregroundColor(.white)
            .background(.primary)
            .cornerRadius(10)
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButtonLabel(title: "Test")
    }
}
