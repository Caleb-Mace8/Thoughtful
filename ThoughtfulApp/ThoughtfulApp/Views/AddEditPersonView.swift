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
    @State var router = PeopleRouter()
    @State var person: Person = .init(name: "", age: 0, birthday: Date(), notifications: false, wishlists: [])
    @State var notificationDate: Date = Date()
    @State var notificationSelection: NotificationTimePreset = .aWeekBefore
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment:.top) {
                Text("Add a New Person")
                    .font(.title.bold())
                Spacer()
                Button {
                    person.timeBeforeNotification = notificationDate
                    context.insert(person)
                    router.dismissSheet()
                    dismiss()
                } label: {
                    Text("Save")
                }
                .buttonStyle(.glassProminent)
            }
            .padding()
            Spacer()
            HStack {
                Text("Name: ")
                Spacer()
                TextField("Enter a name...", text: $person.name)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.vertical)
            DatePicker("Birthday", selection: $person.birthday, displayedComponents: .date)
                .padding(.vertical)
            Text("Age: \(person.age)")
                .padding(.vertical)
            Toggle("Birthday Reminder", isOn: $person.notifications)
                .padding(.vertical)
            VStack {
                HStack {
                    Text("Date of Reminder: ")
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
            .padding(.vertical)
            .overlay {
                if !person.notifications {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray.opacity(0.75))
                }
            }
            Spacer()
        }
        .padding()
        .onChange(of: notificationSelection) {
            if notificationSelection != .custom {
                notificationDate = Calendar.current.date(byAdding: .day, value: notificationSelection.dayOffset, to: person.birthday)!
            }
        }
        .onChange(of: person.birthday) { _, newValue in
            person.age = Calendar.current.dateComponents([.year], from: newValue, to: Date()).year!
        }
        .onChange(of: person.notifications) { _, _ in
            notificationDate = Calendar.current.date(byAdding: .day, value: -7, to: person.birthday)!
        }
    }
}

struct EditPersonView: View {
    @State var person: Person
    init(person: Person) {
        self.person = person
    }
    var body: some View {
        VStack {
            Text("EditPersonView")
        }
        .navigationTitle("Edit a Person")
    }
}
