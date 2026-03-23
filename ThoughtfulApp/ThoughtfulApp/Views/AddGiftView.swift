//
//  AddGiftView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI
import SwiftData

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
        ScrollView {
            VStack {
                HStack {
                    Text("Gift Title:")
                        .bold()
                    TextField("Title...", text: $gift.title)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.vertical)
                HStack {
                    Text("Gift Description:")
                        .bold()
                    TextField("Gift Description...", text: $gift.giftDescription, axis: .vertical)
                        .lineLimit(1...6)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.vertical)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.ultraThinMaterial)
            }
            HStack {
                Text("Price")
                    .bold()
                Spacer()
                HStack {
                    Text("$")
                        .bold()
                    TextField("Enter Budget...", text: $price)
                        .keyboardType(.decimalPad)
                        .frame(minWidth: 75, maxWidth: 125)
                        .onSubmit {
                            guard !price.isEmpty else { return }
                            if String(format: "%.2f", self.gift.price) != price {
                                if let newValueDouble = Double(price) {
                                    gift.price = newValueDouble
                                }
                            }
                        }
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke()
                        .foregroundStyle(.secondary.opacity(0.2))
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.ultraThinMaterial)
            }
            .padding(.vertical)
            VStack {
                HStack {
                    Text("Status of the Gift:")
                        .bold()
                        .padding(.top, 20)
                    Spacer()
                }
                Picker("Gift Status", selection: $gift.giftStatus) {
                    ForEach(GiftStatus.allCases, id: \.self) { status in
                        Text(status.name)
                            .bold()
                            .padding()
                    }
                }
                .frame(height: 150)
                .pickerStyle(.inline)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.ultraThinMaterial)
            }
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
