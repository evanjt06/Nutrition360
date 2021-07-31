//
//  ProgressView.swift
//  Project17
//
//  Created by Evan Tu on 7/8/21.
//

import SwiftUI

struct ProgressView: View {
    
    var week: (String, String)

    var body: some View {
        VStack {
            Text("Week of \(week.0) - \(week.1)")
                .font(.subheadline)
                .foregroundColor(.gray)
//            XLineChartView(entries: Transaction.dataEntriesForWeek(TODO, Transaction.allTransactions))
        }.padding()
    }
}
