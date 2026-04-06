//
//  GiftModel.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import Foundation
import SwiftData

enum GiftStatus: String, Codable, CaseIterable {
    case notBought
    case inShipping
    case purchased
    case delivered
    case wrapped
    
    var name: String {
        switch self {
            case .notBought:
                "Unpurchased"
            case .inShipping:
                "In transit"
            case .purchased:
                "Purchased"
            case .delivered:
                "Delivered"
            case .wrapped:
                "Wrapped"
        }
    }
}

@Model
final class Gift: Identifiable {
    var id: UUID = UUID()
    var title: String
    var giftDescription: String
    var image: String?
    var giftStatus: GiftStatus
    var price: Double
    var wishlist: Wishlist
    var link: String? = nil
    
    init (title: String, giftDescription: String, price: Double, wishlist: Wishlist, giftStatus: GiftStatus = .notBought) {
        self.title = title
        self.giftDescription = giftDescription
        self.price = price
        self.wishlist = wishlist
        self.giftStatus = giftStatus
    }
}
