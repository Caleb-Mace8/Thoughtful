//
//  WishlistView.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/24/26.
//

import SwiftUI
import SwiftData

struct WishlistView: View {
    @Environment(\.modelContext) var context
    @State var wishlist: Wishlist
    @State var isPresenting: Bool = false
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(wishlist.title)
                        .font(.title.bold())
                    Spacer()
                }
                HStack {
                    Text(wishlist.createdAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.ultraThinMaterial)
            }
            List {
                ForEach(wishlist.gifts) { gift in
                    NavigationLink {
                        GiftView(gift: gift)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(gift.title)
                                .bold()
                            Text("$\(gift.price, specifier: "%.2f")")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { offset in
                    for index in offset {
                        let gift = wishlist.gifts[index]
                        context.delete(gift)
                    }
                }
            }
        }
        .sheet(isPresented: $isPresenting) {
            NavigationStack {
                AddEditGiftView(wishlist: wishlist)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    isPresenting = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.glassProminent)
                .tint(.accent)
            }
        }
        .padding()
        .scrollIndicators(.hidden)
    }
}
