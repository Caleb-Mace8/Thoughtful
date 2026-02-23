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
    @Environment(MainRouter.self) var router
    @Environment(\.modelContext) var context
    @State var isPresenting: Bool = false
    @State var viewModel = HomeViewModel()
    @State var upcomingBirthdays: [Person] = []
    var body: some View {
        VStack {
            HStack {
                ScrollView {
                    //TODO: Add view for upcoming events and logic for fetching those people
                    ForEach(upcomingBirthdays) { person in
                        
                    }
                }
            }
            List {
                ForEach(people) { person in
                    Button {
                        router.navigateTo(.personView(person: person))
                    } label: {
                        Text(person.name)
                            .font(.largeTitle.bold())
                    }
                }
            }
        }
        .onAppear {
            upcomingBirthdays = viewModel.findUpcomingEvents()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    router.navigateTo(.addEditPersonView(person: nil))
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle("People")
    }
}

