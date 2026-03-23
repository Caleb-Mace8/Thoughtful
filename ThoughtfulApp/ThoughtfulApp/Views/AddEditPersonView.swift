//
//  AddEditPersonView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI
import SwiftData

struct AddEditPersonView: View {
    var person: Person?
    var body: some View {
        if let person {
            EditPersonView(person: person)
        } else {
            AddPersonView()
        }
    }
}

enum NotificationTimePreset: String, CaseIterable, Identifiable {
    case aWeekBefore
    case twoWeeksBefore
    case aMonthBefore
    case custom
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
            case .aWeekBefore:
                return "A Week Before"
            case .twoWeeksBefore:
                return "Two Weeks Before"
            case .aMonthBefore:
                return "A Month Before"
            case .custom:
                return "Custom"
        }
    }
    
    var dayOffset: Int {
        switch self {
            case .aWeekBefore:
                return -7
            case .twoWeeksBefore:
                return -14
            case .aMonthBefore:
                return -30
            case .custom:
                return 0
        }
    }
}

struct AddPersonView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var person: Person = .init(name: "", age: 0, birthday: Date(), notifications: false, wishlists: [Wishlist(title: Calendar.current.component(.year, from: Date.now).description, author: "", gifts: [], budget: 0.0)], notes: "Favorite Color: ")
    @State var notificationDate: Date = Date()
    @State var notificationSelection: NotificationTimePreset = .aWeekBefore
    @State var budget: Double = 0
    @State var budgetString: String = "0.00"
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Name: ")
                        .bold()
                    Spacer()
                    TextField("Enter a name...", text: $person.name)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.vertical)
                DatePicker("Birthday", selection: $person.birthday, displayedComponents: .date)
                    .padding(.vertical)
                    .bold()
                HStack {
                    Text("Age:")
                        .bold()
                    Spacer()
                    Text("\(person.age)")
                        .bold()
                }
                .padding(.vertical)
                Toggle("Birthday Reminder", isOn: $person.notifications)
                    .bold()
                    .padding(.vertical)
                if person.notifications {
                    VStack {
                        HStack {
                            Text("Date of Reminder: ")
                                .bold()
                            Text(notificationDate.formatted(date: .long, time: .omitted).split(separator: ",")[0])
                            Spacer()
                            Picker("", selection: $notificationSelection) {
                                ForEach(NotificationTimePreset.allCases) { preset in
                                    Text(preset.title).tag(preset)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        .padding(.vertical)
                        if notificationSelection == .custom {
                            DatePicker("Notification Date", selection: $notificationDate, displayedComponents: .date)
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical)
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
                                    if String(format: "%.2f", self.budget) != budgetString {
                                        if let newValueDouble = Double(budgetString) {
                                            budget = newValueDouble
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
                    Slider(value: $budget, in: 0...3000, step: 1)
                        .padding(.vertical)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.ultraThinMaterial)
                }
            }
            .padding()
            .onChange(of: budget) { _, _ in
                let formattedBudget = String(format: "%.2f", self.budget)
                self.budgetString = formattedBudget
            }
            .onChange(of: notificationSelection) {
                if notificationSelection != .custom {
                    notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
                }
            }
            .onChange(of: person.birthday) {
                if notificationSelection != .custom {
                    notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
                }
            }
            .onChange(of: person.notifications) {
                if notificationSelection != .custom {
                    notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        person.timeBeforeNotification = notificationDate
                        person.wishlists[0].budget = budget
                        person.timeBeforeNotification = notificationDate
                        context.insert(person)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                }
            }
        }
    }
}

struct EditPersonView: View {
    @State var person: Person
    @State var budgetString: String = "0.00"
    @State var notificationDate: Date = Date()
    @State var notificationSelection: NotificationTimePreset = .aWeekBefore
    @Environment(\.dismiss) var dismiss
    init(person: Person) {
        self.person = person
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Name: ")
                    .bold()
                Spacer()
                TextField("Enter a name...", text: $person.name)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.vertical)
            DatePicker("Birthday", selection: $person.birthday, displayedComponents: .date)
                .padding(.vertical)
                .bold()
            HStack {
                Text("Age:")
                    .bold()
                Spacer()
                Text("\(person.age)")
                    .bold()
            }
            .padding(.vertical)
            Toggle("Birthday Reminder", isOn: $person.notifications)
                .bold()
                .padding(.vertical)
            if person.notifications {
                VStack {
                    HStack {
                        Text("Date of Reminder: ")
                            .bold()
                        Text(notificationDate.formatted(date: .long, time: .omitted).split(separator: ",")[0])
                        Spacer()
                        Picker("", selection: $notificationSelection) {
                            ForEach(NotificationTimePreset.allCases) { preset in
                                Text(preset.title).tag(preset)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.vertical)
                    if notificationSelection == .custom {
                        DatePicker("Notification Date", selection: $notificationDate, displayedComponents: .date)
                            .bold()
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
            }
        }
        .padding()
        .onChange(of: notificationSelection) {
            if notificationSelection != .custom {
                notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
                person.timeBeforeNotification = notificationDate
            }
        }
        .onChange(of: person.birthday) {
            if notificationSelection != .custom {
                notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
            }
        }
        .onChange(of: person.notifications) {
            if notificationSelection != .custom {
                notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
                person.timeBeforeNotification = notificationDate
            }
        }
        .onAppear {
            if let notifcationReminder = person.timeBeforeNotification {
                notificationDate = notifcationReminder
            }
        }
        .navigationTitle("Edit a Person")
    }
}
