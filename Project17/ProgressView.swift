//
//  ProgressView.swift
//  Project17
//
//  Created by Evan Tu on 7/8/21.
//

import SwiftUI
import SwiftUICharts

struct ProgressView: View {
    
    let mixedColorStyle = ChartStyle(backgroundColor: .white, foregroundColor: [
        ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark),
        ColorGradient(.purple, .blue)
    ])
    let orangeStyle = ChartStyle(backgroundColor: .white,
                                 foregroundColor: [ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark)])
    
    @State var data1: [Double] = (0..<16).map { _ in .random(in: 9.0...100.0) }
    @State var data2: [Double] = (0..<16).map { _ in .random(in: 9.0...100.0) }
    

    var body: some View {
        GeometryReader { geometry in
            VStack {
                CardView {
                    ChartLabel("Total Calories this month", type: .legend)
                    BarChart()
                }
                .data(data2)
                .chartStyle(orangeStyle)
                .frame(maxWidth: geometry.size.width)
                .padding(20)

                CardView {
                    ChartLabel("Total Calories this month", type: .legend)
                    BarChart()
                }
                .data(data1)
                .chartStyle(mixedColorStyle)
                .frame(maxWidth: geometry.size.width)
                .padding(20)
            }
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
