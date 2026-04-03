//
//  UpcomingBirthdaysCardSubview.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/23/26.
//

import Foundation
import SwiftUI

struct UpcomingBirthdaysCardSubview: View {
    var person: Person
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 75, height: 75)
                .foregroundStyle(.ultraThickMaterial)
            Spacer()
            VStack(alignment: .trailing) {
                Text(person.name)
                    .foregroundStyle(.ultraThickMaterial)
                    .bold()
                Text(person.birthday.formatted(date: .long, time: .omitted).split(separator: ",")[0])
                    .foregroundStyle(.ultraThickMaterial)
                Text("Turning: \(person.age + 1)")
                    .foregroundStyle(.ultraThickMaterial)
            }
        }
        .frame(width: 200, height: 65)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.accent)
        }
    }
}
