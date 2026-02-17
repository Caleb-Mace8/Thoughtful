//
//  HomeView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Person.name, order: .forward) var people: [Person]
    var body: some View {
        VStack {
           
        }
        .navigationTitle("People")
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Person.self, inMemory: true)
}
