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
    var person: Person? = nil
    var list: Wishlist? = nil
    
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
    var person: Person?
    @State var list: Wishlist = .init(title: "", author: "", gifts: [], budget: 0.00)
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Title:")
                        .bold()
                    TextField("Enter a Title...", text: $list.title)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke()
                                .foregroundStyle(.secondary.opacity(0.2))
                        }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.ultraThinMaterial)
                }
                if person != nil {
                    VStack {
                        HStack {
                            Text("Budget:")
                                .bold()
                            Spacer()
                            HStack {
                                Text("$")
                                    .bold()
                                TextField("Enter a Budget...", text: $budgetString)
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
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke()
                                    .foregroundStyle(.secondary.opacity(0.2))
                            }
                        }
                        .padding(.vertical)
                        Slider(value: $list.budget, in: 0...3000, step: 1)
                            .padding(.vertical)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.ultraThinMaterial)
                    }
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
                        if let person {
                            person.wishlists.append(list)
                        } else {
                            context.insert(list)
                        }
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
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State var list: Wishlist
    @State var budgetString: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Title:")
                        .bold()
                    TextField("", text: $list.title)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke()
                                .foregroundStyle(.secondary.opacity(0.2))
                        }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.ultraThinMaterial)
                }
                if list.assignedPerson != nil {
                    VStack {
                        HStack {
                            Text("Budget:")
                                .bold()
                            Spacer()
                            HStack {
                                Text("$")
                                    .bold()
                                TextField("Enter a Budget...", text: $budgetString)
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
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke()
                                    .foregroundStyle(.secondary.opacity(0.2))
                            }
                        }
                        .padding(.vertical)
                        Slider(value: $list.budget, in: 0...3000, step: 1)
                            .padding(.vertical)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.ultraThinMaterial)
                    }
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
            .toolbar {
                ToolbarItem {
                    Button {
                        context.delete(list)
                        try? context.save()
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}
