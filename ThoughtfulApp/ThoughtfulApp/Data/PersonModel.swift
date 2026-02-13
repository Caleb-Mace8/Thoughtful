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
    var name: String
    var age: Int
    var birthday: Date
    var notifications: Bool
    @Relationship(deleteRule: .cascade, inverse: \Gift.person) var gifts: [Gift]
    
    init(name: String, age: Int, birthday: Date, notifications: Bool, gifts: [Gift]) {
        self.name = name
        self.age = age
        self.birthday = birthday
        self.notifications = notifications
        self.gifts = gifts
    }
}
