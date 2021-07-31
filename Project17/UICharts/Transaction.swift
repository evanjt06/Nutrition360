//
//  Transaction.swift
//  ChartsSample
//
//  Created by Evan Tu on 7/30/21.
//

import Foundation
import Charts

struct Transaction {
    
    var week: String
    var day: Double
    var calories: Double
    
    static func dataEntriesForWeek(_ week: String, _ transactions: [Transaction]) -> [ChartDataEntry] {
        let yt = transactions.filter { week == $0.week }
        
        return yt.map { ChartDataEntry(x: $0.day, y: $0.calories) }
    }
    
    static var days: [String] = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    
    static var allTransactions: [Transaction] {
        
//        todo input custom logic to fetch and create the final Transaction array[]
        [
            Transaction(week: "7/11/21 - 7/17/21", day: 0, calories: 300),
            Transaction(week: "7/11/21 - 7/17/21", day: 1, calories: 500),
            Transaction(week: "7/11/21 - 7/17/21", day: 2, calories: 600),
            Transaction(week: "7/11/21 - 7/17/21", day: 3, calories: 700),
            Transaction(week: "7/11/21 - 7/17/21", day: 4, calories: 800),
            Transaction(week: "7/11/21 - 7/17/21", day: 5, calories: 900),
            Transaction(week: "7/11/21 - 7/17/21", day: 6, calories: 200),
            Transaction(week: "7/18/21 - 7/24/21", day: 0, calories: 300),
            Transaction(week: "7/18/21 - 7/24/21", day: 1, calories: 800),
            Transaction(week: "7/18/21 - 7/24/21", day: 2, calories: 800),
            Transaction(week: "7/18/21 - 7/24/21", day: 3, calories: 700),
            Transaction(week: "7/18/21 - 7/24/21", day: 4, calories: 800),
            Transaction(week: "7/18/21 - 7/24/21", day: 5, calories: 100),
            Transaction(week: "7/18/21 - 7/24/21", day: 6, calories: 100),
        ]
    }
}

