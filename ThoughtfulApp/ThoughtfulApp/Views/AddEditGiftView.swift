//
//  AddEditGiftView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI

struct AddEditGiftView: View {
    var gift: Gift?
    var wishlist: Wishlist
    var body: some View {
        if let gift {
            EditGiftView(gift: gift, wishlist: wishlist)
        } else {
            AddGiftView(wishlist: wishlist)
        }
    }
}

struct AddGiftView: View {
    var wishlist: Wishlist
    var gift: Gift
    
    init(wishlist: Wishlist) {
        self.wishlist = wishlist
        self.gift = .init(title: "", price: 0.0, wishlist: wishlist)
    }
    var body: some View {
        
    }
}


struct EditGiftView: View {
    var gift: Gift
    var wishlist: Wishlist
    var body: some View {
        
    }
}
