//
//  ProgressView.swift
//  Project17
//
//  Created by Evan Tu on 7/8/21.
//

import SwiftUI

struct ProgressView: View {
    
    var weekA: String
    var weekB: String
    var startingVal: Int64
    var endingVal: Int64
    
    var workingDate: Date

    var body: some View {
        VStack {
            Text("Week of \(weekA) - \(weekB)")
                .font(.subheadline)
                .foregroundColor(.gray)
            XLineChartView(entries: Transaction.dataEntriesForWeek("\(startingVal)", Transaction.allTransactions(starting: startingVal, ending: endingVal, workingDate: workingDate)))
        }.padding()
    }
}
