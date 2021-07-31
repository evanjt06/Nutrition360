//
//  ProgressView.swift
//  Project17
//
//  Created by Evan Tu on 7/8/21.
//

import SwiftUI

struct ProgressView: View {
    
    var week: String

    var body: some View {
        VStack {
            Text("Week of \(week)")
                .font(.subheadline)
                .foregroundColor(.gray)
            XLineChartView(entries: Transaction.dataEntriesForWeek(self.week, Transaction.allTransactions))
        }.padding()
    }
}
