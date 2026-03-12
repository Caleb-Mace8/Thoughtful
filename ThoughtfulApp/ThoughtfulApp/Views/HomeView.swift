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
    @Environment(\.modelContext) var context
    @State var viewModel = HomeViewModel()
    @State var upcomingBirthdays: [Person] = []
    var body: some View {
        NavigationStack {
            List {
                if !upcomingBirthdays.isEmpty {
                    Section("Upcoming") {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(upcomingBirthdays) { person in
                                    NavigationLink(destination: PersonView(person: person)) {
                                        UpcomingBirthdaysCardSubview(person: person)
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                Section {
                    ForEach(people) { person in
                        NavigationLink {
                            PersonView(person: person)
                        } label: {
                            Text(person.name)
                        }
                    }
                    .onDelete(perform: { offset in
                        let toDelete = offset.map { people[$0] }
                        for i in toDelete {
                            context.delete(i)
                        }
                    })
                }
            }
            .onAppear {
                viewModel.people = people
                upcomingBirthdays = viewModel.findUpcomingEvents()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        viewModel.person = nil
                        viewModel.isPresenting.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                }
            }
            .sheet(isPresented: $viewModel.isPresenting) {
                AddEditPersonView(person: viewModel.person)
            }
            .navigationTitle("People")
        }
    }
}

