    //
    //  AddEditGiftView.swift
    //  ThoughtfulApp
    //
    //  Created by Caleb Mace on 2/13/26.
    //

import SwiftUI
import SwiftData

private struct TapToCommitAndDismiss: ViewModifier {
    let commit: () -> Void
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                commit()
                // Dismiss keyboard on iOS
                #if canImport(UIKit)
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                #endif
            }
    }
}

private extension View {
    func onBackgroundTapCommit(_ commit: @escaping () -> Void) -> some View {
        self.modifier(TapToCommitAndDismiss(commit: commit))
    }
}

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
    var priceIsntRight: Bool {
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
            ScrollView {
                VStack {
                    HStack {
                        Text("Gift Title:")
                            .bold()
                        TextField("Enter a Title...", text: $gift.title)
                            .padding()
                            .submitLabel(.return)
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke()
                                    .foregroundStyle(.secondary.opacity(0.2))
                            }
                    }
                    .padding(.vertical)
                    HStack {
                        Text("Gift Description:")
                            .bold()
                        TextField("Enter a Gift Description...", text: $gift.giftDescription, axis: .vertical)
                            .lineLimit(1...6)
                            .submitLabel(.return)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke()
                                    .foregroundStyle(.secondary.opacity(0.2))
                            }
                    }
                    .padding(.vertical)
                    HStack {
                        Text("Link to Gift:")
                            .bold()
                        TextField("Enter a Link...", text: $link)
                            .padding()
                            .submitLabel(.return)
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke()
                                    .foregroundStyle(.secondary.opacity(0.2))
                            }
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
                        TextField("0.00", text: $price)
                            .keyboardType(.decimalPad)
                            .submitLabel(.return)
                            .frame(minWidth: 75, maxWidth: 125)
                    }
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
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
            .scrollDismissesKeyboard(.interactively)
            .padding()
            .onBackgroundTapCommit {
                guard !price.isEmpty else { return }
                if String(format: "%.2f", self.gift.price) != price {
                    if let newValueDouble = Double(price) {
                        gift.price = newValueDouble
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
                .disabled(priceIsntRight)
                .buttonStyle(.glassProminent)
                .tint(.accent)
            }
            .navigationTitle("Add a Gift")
        }
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
    @FocusState private var isFocused: Bool
    var priceIsntRight: Bool {
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
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                            Text("Gift Title:")
                                .bold()
                            TextField("Enter a Title...", text: $title)
                                .padding()
                                .submitLabel(.return)
                                .background {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke()
                                        .foregroundStyle(.secondary.opacity(0.2))
                                }
                        }
                        .padding(.vertical)
                        HStack {
                            Text("Gift Description:")
                                .bold()
                            TextField("Enter a Gift Description...", text: $giftDescription, axis: .vertical)
                                .lineLimit(1...6)
                                .submitLabel(.return)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(.ultraThinMaterial)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke()
                                                .foregroundStyle(.secondary.opacity(0.2))
                                        }
                                }
                        }
                        .padding(.vertical)
                        HStack {
                            Text("Link to Gift:")
                                .bold()
                            TextField("Enter a Link...", text: $link)
                                .submitLabel(.return)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke()
                                        .foregroundStyle(.secondary.opacity(0.2))
                                }
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
                            TextField("0.00", text: $price)
                                .keyboardType(.decimalPad)
                                .frame(minWidth: 75, maxWidth: 125)
                        }
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
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
                .padding()
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
                    .disabled(priceIsntRight)
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                }
                .navigationTitle("Edit a Gift")
            }
            .scrollDismissesKeyboard(.interactively)
            .onBackgroundTapCommit {
                guard !price.isEmpty else { return }
                if String(format: "%.2f", self.gift.price) != price {
                    if let newValueDouble = Double(price) {
                        gift.price = newValueDouble
                    }
                }
                gift.title = title
                gift.giftDescription = giftDescription
                gift.link = link
            }
        }
    }
}

