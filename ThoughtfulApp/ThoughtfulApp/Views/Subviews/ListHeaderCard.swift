//
//  ListHeaderCard.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/17/26.
//

import SwiftUI

struct ListHeaderCard: View {
    var list: Wishlist
    var body: some View {
        VStack {
            HStack {
                Text(list.title)
                Spacer()
                NavigationLink {
                    AddEditGiftView(wishlist: list)
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 45, height: 30)
                }
                .buttonStyle(.glassProminent)
                .tint(.accent)
            }
            VStack(alignment: .leading) {
                Capsule()
                    .foregroundStyle(.ultraThickMaterial)
                    .frame(width: 350, height: 50)
                    .overlay {
                        Capsule()
                            .foregroundStyle(.green)
                            .frame(width: 175, height: 50)
                    }
            }
        }
        .frame(width: 400)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.card)
        }
    }
}
