//
//  AddEditGiftView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 2/13/26.
//

import SwiftUI
import SwiftData

struct AddEditGiftView: View {
    var wishlist: Wishlist
    var gift: Gift? = nil
    var body: some View {
        if let gift {
            EditGiftView(gift: gift)
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
    @State var link: String = ""
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
            VStack {
                HStack {
                    Text("Gift Title:")
                        .bold()
                    TextField("Enter a Title...", text: $gift.title)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.vertical)
                HStack {
                    Text("Gift Description:")
                        .bold()
                    TextField("Enter a Gift Description...", text: $gift.giftDescription, axis: .vertical)
                        .lineLimit(1...6)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.vertical)
                HStack {
                    Text("Link to Gift:")
                        .bold()
                    TextField("Enter a Link...", text: $link)
                        .textFieldStyle(.roundedBorder)
                }
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
                    TextField("Enter a Price...", text: $price)
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
            if wishlist.assignedPerson != nil {
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
        }
        .toolbar {
            Button {
                if let price = Double(price) {
                    gift.price = price
                    gift.link = link
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
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var title: String = ""
    @State var giftDescription: String = ""
    @State var price: String = ""
    @State var link: String = ""
    @State var gift: Gift
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
    var body: some View {
        VStack {
            VStack {
                VStack {
                    HStack {
                        Text("Gift Title:")
                            .bold()
                        TextField("Enter a Title...", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.vertical)
                    HStack {
                        Text("Gift Description:")
                            .bold()
                        TextField("Enter a Gift Description...", text: $giftDescription, axis: .vertical)
                            .lineLimit(1...6)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.vertical)
                    HStack {
                        Text("Link to Gift:")
                            .bold()
                        TextField("Enter a Link...", text: $link)
                            .textFieldStyle(.roundedBorder)
                    }
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
                        TextField("Enter a Price...", text: $price)
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
                if gift.wishlist.assignedPerson != nil {
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
            }
            .onAppear {
                title = gift.title
                giftDescription = gift.giftDescription
                price = "\(gift.price, default: "%.2f")"
                if let link = gift.link {
                    self.link = link
                }
            }
            .toolbar {
                Button {
                    if let price = Double(price) {
                        gift.title = title
                        gift.giftDescription = giftDescription
                        gift.price = price
                        gift.link = link
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
            .navigationTitle("Edit a Gift")
        }
    }
}
