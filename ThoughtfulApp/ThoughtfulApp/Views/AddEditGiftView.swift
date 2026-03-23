//
//  AddEditGiftView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI
import SwiftData

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
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var gift: Gift
    @State var price: String = ""
    var pirceIsntRight: Bool {
        for character in price {
            if !character.isNumber {
                if character == "." {
                    break
                } else {
                    return true
                }
            }
        }
        return false
    }
    
    init(wishlist: Wishlist) {
        self.wishlist = wishlist
        self.gift = .init(title: "", giftDescription: "", price: 0.0, wishlist: wishlist)
    }
    var body: some View {
        VStack {
            HStack {
                Text("Gift Title:")
                    .bold()
                TextField("", text: $gift.title)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.vertical)
            HStack {
                Text("Gift Description:")
                    .bold()
                TextField("", text: $gift.giftDescription)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.vertical)
            HStack {
                Text("Price")
                    .bold()
                TextField("", text: $price)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
            .padding(.vertical)
            Picker("Gift Status", selection: $gift.giftStatus) {
                ForEach(GiftStatus.allCases, id: \.self) { status in
                    Text(status.name)
                }
            }
            .pickerStyle(.palette)
            .padding(.vertical)
        }
        .toolbar {
            Button {
                if let price = Double(price) {
                    gift.price = price
                    wishlist.gifts.append(gift)
                    try? context.save()
                    dismiss()
                }
            } label: {
                Text("Save")
            }
            .disabled(pirceIsntRight)
            .buttonStyle(.glassProminent)
            .tint(.accent)
        }
        .padding()
        .navigationTitle("Add a Gift")
    }
}


struct EditGiftView: View {
    var gift: Gift
    var wishlist: Wishlist
    var body: some View {
        
    }
}
