    //
    //  PersonView.swift
    //  ThoughtfulApp
    //
    //  Created by Caleb Mace on 2/13/26.
    //

import SwiftUI

struct PersonView: View {
    @State var person: Person
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.accent)
                            Spacer()
                            VStack {
                                Text(person.name)
                                    .font(.title.bold())
                                Text(person.birthday.formatted(date: .long, time: .omitted).split(separator: ",")[0])
                                    .font(.title2)
                                Text("\(person.age) " + (person.age == 1 ? "Year Old" : "Years Old"))
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $person.notes)
                        .frame(minHeight: 150)
                }
                
                ForEach(person.wishlists) { list in
                    Section(header: ListHeaderCard(list: list)) {
                        if list.gifts.isEmpty {
                            Text("No Gifts Found in This List.")
                        } else {
                            ForEach(list.gifts) { gift in
                                NavigationLink {
                                    GiftView(gift: gift)
                                } label: {
                                    Text(gift.title)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        AddEditListView()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                }
            }
        }
    }
}
