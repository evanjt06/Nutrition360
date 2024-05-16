//
//  TransactionBarChartView.swift
//  ChartsSample
//
//  Created by Evan Tu on 7/30/21.
//

import SwiftUI
import Charts

struct XLineChartView: UIViewRepresentable {
    
    let entries: [ChartDataEntry]
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataset = LineChartDataSet(entries: entries)
        
        dataset.label = "Amount of calories"
        uiView.noDataText = "No data"
        uiView.data = LineChartData(dataSet: dataset)
        uiView.rightAxis.enabled = false
        
        uiView.setScaleEnabled(false)
        
        dataset.colors = [.orange]
        dataset.valueFont = UIFont(name: "Times", size: 11.0)!
        dataset.circleColors = [.black]
        
        let f = NumberFormatter()
        f.numberStyle = .none
        dataset.valueFormatter = DefaultValueFormatter(formatter: f)
        
        uiView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: f)
        uiView.leftAxis.axisMinimum = 0
        
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: Transaction.days)
        uiView.xAxis.labelPosition = .bottom
        
        uiView.legend.horizontalAlignment = .right
        uiView.legend.verticalAlignment = .top
        
        uiView.notifyDataSetChanged()
    }
}

