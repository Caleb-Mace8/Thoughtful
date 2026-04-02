    //
    //  ListsRootView.swift
    //  ThoughtfulApp
    //
    //  Created by Caleb Mace on 3/9/26.
    //

import SwiftUI
import SwiftData

struct ListsRootView: View {
    @Query(sort: \Wishlist.title, order: .forward) var allLists: [Wishlist]
    @Environment(\.modelContext) var context
    @State var lists: [Wishlist] = []
    @State var isPresentingSheet: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                if lists.isEmpty {
                    VStack {
                        HStack {
                            Text("Create Your First Wishlist!")
                                .bold()
                            Button {
                                isPresentingSheet = true
                            } label: {
                                Image(systemName: "plus")
                            }
                            .buttonStyle(.glassProminent)
                            .tint(.accent)
                            .buttonBorderShape(.circle)
                        }
                    }
                } else {
                    List {
                        ForEach (lists) { wishlist in
                            NavigationLink {
                                WishlistView(wishlist: wishlist)
                            } label: {
                                Text(wishlist.title)
                            }
                            .swipeActions(edge: .leading) {
                                NavigationLink {
                                    AddEditListView(list: wishlist)
                                } label: {
                                    Image(systemName: "pencil")
                                    Text("Edit")
                                }
                                .tint(.blue)
                            }
                        }
                        .onDelete { offset in
                            let toDelete = offset.map { lists[$0] }
                            for i in toDelete {
                                context.delete(i)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Lists")
            .toolbar {
                ToolbarItem {
                    Button {
                        isPresentingSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                }
            }
            .sheet(isPresented: $isPresentingSheet) {
                AddEditListView(person: nil)
                    .presentationDetents([.medium])
            }
        }
        .onAppear {
            lists = allLists.filter { $0.assignedPerson == nil }
        }
        .onChange(of: allLists) {
            lists = allLists.filter { $0.assignedPerson == nil }
        }
    }
}
