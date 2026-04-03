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

struct AddPersonView: View {
    @Environment(NotificationManager.self) var notificationManager
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var person: Person = .init(name: "", age: 0, birthday: Date(), notifications: false, wishlists: [Wishlist(title: Calendar.current.component(.year, from: Date.now).description, author: "", gifts: [], budget: 0.0)], notes: "Favorite Color: ")
    @State var notificationDate: Date = Date()
    @State var notificationSelection: NotificationTimePreset = .aWeekBefore
    @State var budget: Double = 0
    @State var budgetString: String = ""
    @State var showAlert: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name: ")
                            .bold()
                        Spacer()
                        TextField("Enter a name...", text: $person.name)
                            .padding()
                            .submitLabel(.return)
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke()
                                    .foregroundStyle(.secondary.opacity(0.2))
                            }
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
                                TextField("0.00", text: $budgetString)
                                    .keyboardType(.decimalPad)
                                    .frame(minWidth: 50, maxWidth: 100)
                            }
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke()
                                    .foregroundStyle(.secondary.opacity(0.2))
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding()
                .alert("Enable Notifications in Settings", isPresented: $showAlert) {
                    HStack {
                        Button {
                            person.notifications = false
                            showAlert = false
                        } label: {
                            Text("Dismiss")
                        }
                        Button {
                            Task {
                                let url = URL(string:UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Settings")
                        }
                    }
                }
                // Converts Double to a String trimming off all decimal places after the second.
                .onChange(of: budget) {
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
                    if person.notifications == true {
                        showSettingsPromptIfNeeded()
                    }
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
                            guard !budgetString.isEmpty else { return }
                            if String(format: "%.2f", self.budget) != budgetString {
                                if let newValueDouble = Double(budgetString) {
                                    budget = newValueDouble
                                }
                            }
                            person.notificationDate = notificationDate
                            person.wishlists[0].budget = budget
                            person.notificationDate = notificationDate
                            notificationManager.scheduleNotification(for: person)
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
            .scrollDismissesKeyboard(.interactively)
            .dismissKeyboardOnTap()
        }
    }
    
    func showSettingsPromptIfNeeded() {
        notificationManager.checkAuthorizationStatus { status in
            guard status == .denied else { return }
            showAlert = true
        }
    }
}

struct EditPersonView: View {
    @Environment(NotificationManager.self) var notificationManager
    @State var person: Person
    @State var budgetString: String = "0.00"
    @State var notificationDate: Date = Date()
    @State var notificationSelection: NotificationTimePreset? = nil
    @Environment(\.dismiss) var dismiss
    @State var showAlert: Bool = false
    init(person: Person) {
        self.person = person
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Name: ")
                        .bold()
                    Spacer()
                    TextField("Enter a name...", text: $person.name)
                        .padding()
                        .submitLabel(.return)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke()
                                .foregroundStyle(.secondary.opacity(0.2))
                        }
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
                            Picker("Pick a Date...", selection: $notificationSelection) {
                                Text("Select a Preset…").tag(NotificationTimePreset?.none)
                                
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
            .alert("Enable Notifications in Settings", isPresented: $showAlert) {
                HStack {
                    Button {
                        person.notifications = false
                        showAlert = false
                    } label: {
                        Text("Dismiss")
                    }
                    Button {
                        Task {
                            let url = URL(string:UIApplication.openSettingsURLString)!
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Settings")
                    }
                }
            }
            .onChange(of: notificationSelection) {
                if notificationSelection != .custom {
                    if let notificationSelection {
                        notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
                    }
                }
            }
            .onChange(of: person.birthday) {
                if notificationSelection != .custom {
                    if let notificationSelection {
                        notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
                    }
                }
            }
            .onChange(of: person.notifications) {
                if person.notifications == true {
                    showSettingsPromptIfNeeded()
                }
                if notificationSelection != .custom {
                    if let notificationSelection {
                        notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
                    }
                }
            }
            .onChange(of: notificationDate) {
                if person.notificationDate == nil {
                    person.notificationDate = notificationDate
                    notificationManager.scheduleNotification(for: person)
                } else {
                    person.notificationDate = notificationDate
                    notificationManager.rescheduleNotification(for: person)
                }
            }
            .onAppear {
                if person.notifications == true {
                    if let notifcationReminder = person.notificationDate {
                        notificationDate = notifcationReminder
                    }
                }
            }
            .navigationTitle("Edit a Person")
        }
        .scrollDismissesKeyboard(.interactively)
        .dismissKeyboardOnTap()
    }
    func showSettingsPromptIfNeeded() {
        notificationManager.checkAuthorizationStatus { status in
            guard status == .denied else { return }
            showAlert = true
        }
    }
}
