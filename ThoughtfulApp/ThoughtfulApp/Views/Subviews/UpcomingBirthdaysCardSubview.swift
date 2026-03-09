//
//  UpcomingBirthdaysCardSubview.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/23/26.
//

import Foundation
import SwiftUI
    
//TODO: Create card subview.

struct UpcomingBirthdaysCardSubview: View {
    var person: Person
    var colors: [Color] = [.cardColor1, .cardColor2]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(colors.randomElement()!)
        }
    }
}
