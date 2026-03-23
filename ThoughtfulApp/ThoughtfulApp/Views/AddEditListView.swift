//
//  AddEditListView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/17/26.
//

import SwiftUI
import Foundation
import SwiftData

struct AddEditListView: View {
    var person: Person
    var list: Wishlist? = nil
    
    init(person: Person, list: Wishlist? = nil) {
        self.person = person
        self.list = list
    }
    
    var body: some View {
        if let wishlist = list {
            EditListView(list: wishlist)
        } else {
            AddListView(person: person)
        }
    }
}

struct AddListView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var budgetString: String = ""
    var person: Person
    @State var list: Wishlist = .init(title: "", author: "", gifts: [], budget: 0.00)
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Title:")
                    TextField("", text: $list.title)
                        .textFieldStyle(.roundedBorder)
                }
                VStack {
                    HStack {
                        Text("Budget:")
                            .bold()
                        Spacer()
                        HStack {
                            Text("$")
                                .bold()
                            TextField("Enter Budget...", text: $budgetString)
                                .keyboardType(.decimalPad)
                                .frame(minWidth: 50, maxWidth: 100)
                                .onSubmit {
                                    guard !budgetString.isEmpty else { return }
                                    if String(format: "%.2f", self.list.budget) != budgetString {
                                        if let newValueDouble = Double(budgetString) {
                                            list.budget = newValueDouble
                                        }
                                    }
                                }
                        }
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .foregroundStyle(.secondary.opacity(0.2))
                        }
                    }
                    .padding(.vertical)
                    Slider(value: $list.budget, in: 0...3000, step: 1)
                        .padding(.vertical)
                }
            }
            .onAppear {
                let formattedBudget = String(format: "%.2f", self.list.budget)
                self.budgetString = formattedBudget
            }
            .onChange(of: list.budget) { _, _ in
                let formattedBudget = String(format: "%.2f", self.list.budget)
                self.budgetString = formattedBudget
            }
            .padding()
            .toolbar {
                ToolbarItem {
                    Button {
                        person.wishlists.append(list)
                        try? context.save()
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                }
            }
            .navigationTitle("Add a List")
        }
    }
}

struct EditListView: View {
    @State var list: Wishlist
    @State var budgetString: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Title:")
                        .bold()
                    TextField("", text: $list.title)
                        .textFieldStyle(.roundedBorder)
                }
                VStack {
                    HStack {
                        Text("Budget:")
                            .bold()
                        Spacer()
                        HStack {
                            Text("$")
                                .bold()
                            TextField("Enter Budget...", text: $budgetString)
                                .keyboardType(.decimalPad)
                                .frame(minWidth: 50, maxWidth: 100)
                                .onSubmit {
                                    guard !budgetString.isEmpty else { return }
                                    if String(format: "%.2f", self.list.budget) != budgetString {
                                        if let newValueDouble = Double(budgetString) {
                                            list.budget = newValueDouble
                                        }
                                    }
                                }
                        }
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .foregroundStyle(.secondary.opacity(0.2))
                        }
                    }
                    .padding(.vertical)
                    Slider(value: $list.budget, in: 0...3000, step: 1)
                        .padding(.vertical)
                }
            }
            .onAppear {
                let formattedBudget = String(format: "%.2f", self.list.budget)
                self.budgetString = formattedBudget
            }
            .onChange(of: list.budget) { _, _ in
                let formattedBudget = String(format: "%.2f", self.list.budget)
                self.budgetString = formattedBudget
            }
            .padding()
            .navigationTitle("Edit a List")
        }
    }
}
