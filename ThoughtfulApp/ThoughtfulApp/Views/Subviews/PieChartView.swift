    //
    //  PieChartView.swift
    //  ThoughtfulApp
    //
    //  Created by Caleb Mace on 3/24/26.
    //

import SwiftUI
import Charts

struct PieChartView: View {
    var data: [ChartData]
    var percentage: Double
    var body: some View {
        VStack {
            Chart(data) { dataPoint in
                SectorMark(
                    angle: .value("Value", dataPoint.value),
                    innerRadius: .ratio(0.6),
                    angularInset: 1.0
                )
                .foregroundStyle(dataPoint.color)
                .cornerRadius(5.0)
            }
            .chartLegend(.hidden)
            .frame(height: 300)
        }
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    Text("\(percentage * 100, specifier: "%.0f")%")
                        .font(.title.bold())
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
    }
}
