//
//  ChartData.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 3/24/26.
//

import SwiftUI
import Foundation
import Charts

struct ChartData: Identifiable {
    let category: String
    let value: Double
    let id = UUID()
    let color: Color
}
