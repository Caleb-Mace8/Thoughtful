    //
    //  GiftView.swift
    //  ThoughtfulApp
    //
    //  Created by Caleb Mace on 3/6/26.
    //

import SwiftUI

struct GiftView: View {
    @State var gift: Gift
    
    // Computed properties to find percentages for the the price, then finds the remaining percentage against the percentage take by giftPricePercentage.
    var giftPricePercentage: Double {
        if gift.giftStatus != .notBought {
            return gift.price / gift.wishlist.budget
        } else {
            return 0.0
        }
    }
    var remainingPercentage: Double {
        if gift.giftStatus != .notBought {
            if gift.price > gift.wishlist.budget {
                return 0.0
            } else {
                return 1.0 - giftPricePercentage
            }
        } else {
            return 1.0
        }
    }
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        Text(gift.title)
                            .font(.title.bold())
                        Spacer()
                    }
                    HStack {
                        Text(gift.giftDescription)
                            .font(.title3)
                            .padding(.vertical)
                        Spacer()
                    }
                    HStack {
                        Text("Link:")
                            .bold()
                            // Checks to see if gift has a link value then creates a Link for the URL based off gift.link String value.
                        if let link = gift.link {
                            if let url = URL(string: link) {
                                if !url.absoluteString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    Link(url.absoluteString, destination: url)
                                        .foregroundStyle(.blue)
                                        .underline()
                                }
                            }
                        } else {
                            Text("No Link Found")
                        }
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.ultraThinMaterial)
                }
                if gift.wishlist.assignedPerson != nil {
                    VStack {
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
                    VStack {
                        HStack {
                            Text("Gifts Percent of Budget")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding(.vertical)
                        PieChartView(data: [ChartData(category: "", value: giftPricePercentage, color: .accent), ChartData(category: "", value: remainingPercentage, color: .gray.opacity(0.5))], percentage: giftPricePercentage)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.ultraThinMaterial)
                    }
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    AddEditGiftView(wishlist: gift.wishlist, gift: gift)
                } label: {
                    Text("Edit")
                }
                .buttonBorderShape(.capsule)
            }
        }
    }
}
