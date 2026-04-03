//
//  PersonModel.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import Foundation
import SwiftData

@Model
final class Person: Identifiable {
    var id: UUID = UUID()
    var image: String?
    var name: String
    var age: Int {
        return Calendar.current.dateComponents([.year], from: birthday, to: Date()).year!
    }
    var birthday: Date
    var notifications: Bool
    var notificationDate: Date? = nil
    @Relationship(deleteRule: .cascade, inverse: \Wishlist.assignedPerson) var wishlists: [Wishlist]
    var notes: String
    
    init(name: String, age: Int, birthday: Date, notifications: Bool, wishlists: [Wishlist], notes: String) {
        self.name = name
        self.birthday = birthday
        self.notifications = notifications
        self.wishlists = wishlists
        self.notes = notes
    }
}
