    //
    //  ListHeaderCard.swift
    //  ThoughtfulApp
    //
    //  Created by Caleb Mace on 3/17/26.
    //

import SwiftUI

    // Displayed above lists for Wishlists, contains information such as title, gift count, budget, and buttons for adding gifts and editing the list.

struct ListHeaderCard: View {
    var person: Person
    var list: Wishlist
    var total: Double {
        var count: Double = 0.0
        for gift in list.gifts {
            if gift.giftStatus != GiftStatus.notBought {
                count += gift.price
            }
        }
        return count
    }
    var filledBarPercent: Double {
        let barWidth: Double = 335
        let spent: Double = list.gifts.reduce(0) { partial, gift in
            if gift.giftStatus != GiftStatus.notBought {
                return partial + max(0, gift.price)
            } else {
                return partial
            }
        }
        let budget = max(0, list.budget)
        if budget == 0 { return 0 }
        let progress = min(max(spent / budget, 0), 1)
        return progress * barWidth
    }
    var geometry: GeometryProxy
    var body: some View {
        VStack {
            HStack {
                Text(list.title)
                    .foregroundStyle(.standardizedText)
                    .font(.title.bold())
                Spacer()
                NavigationLink {
                    AddEditListView(person: person, list: list)
                } label: {
                    Image(systemName: "pencil")
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.glassProminent)
                .tint(.blue)
                NavigationLink {
                    AddEditGiftView(wishlist: list)
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.glassProminent)
                .tint(.accent)
            }
            .padding(.vertical)
            HStack {
                Text("Budget: $\(list.budget, format: .number.precision(.fractionLength(2)))")
                    .foregroundStyle(.standardizedText)
                Spacer()
                Text("Gift Count: \(list.gifts.count)")
                    .foregroundStyle(.standardizedText)
            }
            .padding(.vertical)
            HStack {
                Text("$\(total, specifier: "%.2f")")
                    .foregroundStyle(.standardizedText)
                Spacer()
            }
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(.ultraThickMaterial)
                    .frame(width: 335, height: 50)
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(total > list.budget ? Color.red : Color.green)
                    .frame(width: filledBarPercent, height: 50)
            }
        }
        .frame(width: geometry.size.width - 70, height: 250)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.card)
        }
    }
}

