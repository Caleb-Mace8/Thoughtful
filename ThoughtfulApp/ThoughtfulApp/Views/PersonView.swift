    //
    //  PersonView.swift
    //  ThoughtfulApp
    //
    //  Created by Caleb Mace on 2/13/26.
    //

import SwiftUI
import SwiftData

struct PersonView: View {
    @Environment(\.modelContext) var context
    @State var person: Person
    var body: some View {
        GeometryReader { geometry in
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
                        Section(header: ListHeaderCard(person: person, list: list, geometry: geometry)) {
                            if list.gifts.isEmpty {
                                Text("No Gifts Found in This List.")
                            } else {
                                ForEach(list.gifts) { gift in
                                    NavigationLink {
                                        GiftView(gift: gift)
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(gift.title)
                                                .bold()
                                            Text("$\(gift.price, specifier: "%.2f")")
                                                .foregroundStyle(.secondary)
                                            Text("\(gift.giftStatus.name)")
                                        }
                                    }
                                }
                                .onDelete { offset in
                                    for index in offset {
                                        let gift = list.gifts[index]
                                        context.delete(gift)
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .scrollIndicators(.hidden)
                .toolbar {
                    ToolbarItem {
                        NavigationLink {
                            AddEditListView(person: person)
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
}
