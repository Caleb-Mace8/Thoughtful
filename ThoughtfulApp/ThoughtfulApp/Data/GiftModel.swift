//
//  GiftModel.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//
import Foundation
import SwiftData

@Model
final class Gift: Identifiable {
    var id: UUID = UUID()
    var title: String
    var giftDescription: String?
    var image: String?
    var giftStatus: String = "notBought"
    var price: Double
    var person: Person
    
    init (title: String, giftDescription: String? = nil, price: Double, person: Person) {
        self.title = title
        self.giftDescription = giftDescription
        self.price = price
        self.person = person
    }
}
