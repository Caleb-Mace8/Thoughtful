//
//  ListHeaderCard.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/17/26.
//

import SwiftUI

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
        let barWidth: Double = 350
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
    var body: some View {
        VStack {
            HStack {
                Text(list.title)
                    .font(.title.bold())
                Spacer()
                NavigationLink {
                    AddEditListView(person: person, list: list)
                } label: {
                    Image(systemName: "pencil")
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.glass)
                NavigationLink {
                    AddGiftView(wishlist: list)
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
                Spacer()
                Text("Gift Count: \(list.gifts.count)")
            }
            .padding(.vertical)
            HStack {
                Text("$\(total, specifier: "%.2f")")
                Spacer()
            }
            ZStack(alignment: .leading){
                Capsule()
                    .foregroundStyle(.ultraThickMaterial)
                    .frame(width: 350, height: 50)
                Capsule()
                    .foregroundStyle(.green)
                    .frame(width: filledBarPercent, height: 50)
            }
        }
        .padding()
        .padding(.horizontal, 10)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.card)
        }
    }
}

