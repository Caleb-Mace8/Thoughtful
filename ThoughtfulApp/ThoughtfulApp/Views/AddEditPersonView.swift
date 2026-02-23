//
//  AddEditPersonView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI

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
    @State var person: Person = .init(name: "", age: 0, birthday: Date(), notifications: false, gifts: [])
    var body: some View {
        Text("AddPersonView")
    }
}

struct EditPersonView: View {
    @State var person: Person
    init(person: Person) {
        self.person = person
    }
    var body: some View {
        Text("EditPersonView")
    }
}
