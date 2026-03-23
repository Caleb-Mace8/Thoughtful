//
//  WishlistModel.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/9/26.
//

import SwiftData
import Foundation

@Model
final class Wishlist: Identifiable, Hashable {
    var id: UUID = UUID()
    var assignedPerson: Person? = nil
    var title: String
    var author: String
    var createdAt: Date = Date()
    var budget: Double
    @Relationship(deleteRule: .cascade, inverse: \Gift.wishlist) var gifts: [Gift]
    
    init(title: String, author: String, gifts: [Gift], budget: Double?) {
        self.title = title
        self.author = author
        self.gifts = gifts
        if let budget {
            self.budget = budget
        } else {
            self.budget = 0.0
        }
    }
}
