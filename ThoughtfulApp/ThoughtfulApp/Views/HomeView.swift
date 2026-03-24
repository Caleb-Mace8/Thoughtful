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
            Group {
                if people.isEmpty {
                    HStack {
                        Text("Add Your First Person!")
                            .bold()
                        Button {
                            viewModel.person = nil
                            viewModel.isPresenting.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .tint(.accent)
                    }
                } else {
                    List {
                        if !upcomingBirthdays.isEmpty {
                            Section(header: Text("Upcoming Birthdays")
                                .foregroundStyle(.standardizedText)
                                .bold()) {
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
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    NavigationLink {
                                        AddEditPersonView(person: person)
                                    } label: {
                                        Image(systemName: "pencil")
                                        Text("Edit")
                                    }
                                    .tint(.blue)
                                }
                            }
                            .onDelete(perform: { offset in
                                let toDelete = offset.map { people[$0] }
                                for i in toDelete {
                                    context.delete(i)
                                }
                                viewModel.people = people
                                upcomingBirthdays = viewModel.findUpcomingEvents()
                            })
                        }
                    }
                }
            }
            .onChange(of: people) {
                viewModel.people = people
                upcomingBirthdays = viewModel.findUpcomingEvents()
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
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                }
            }
            .sheet(isPresented: $viewModel.isPresenting) {
                AddEditPersonView(person: viewModel.person)
                    .presentationDetents([.fraction(0.8)])
            }
            .navigationTitle("People")
        }
    }
}

