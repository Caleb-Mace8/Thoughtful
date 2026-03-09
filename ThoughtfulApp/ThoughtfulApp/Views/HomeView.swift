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
    @State var router = PeopleRouter()
    @Environment(\.modelContext) var context
    @State var viewModel = HomeViewModel()
    @State var upcomingBirthdays: [Person] = []
    var body: some View {
        VStack {
            HStack {
                ScrollView {
                        //TODO: Add view for upcoming events and logic for fetching those people
                    ForEach(upcomingBirthdays) { person in
                        UpcomingBirthdaysCardSubview(person: person)
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
                    router.present(.addEditPersonView(person: nil))
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.black)
                }
                .buttonStyle(.glassProminent)
                .tint(.accent)
            }
        }
        .sheet(item: $router.sheetPresenting) { sheet in
            switch sheet {
                case .addEditPersonView(let person):
                    AddEditPersonView(person: person)
                case .addEditGiftView:
                    EmptyView()
            }
        }
        .navigationTitle("People")
    }
}

