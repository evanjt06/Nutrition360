//
//  Transaction.swift
//  ChartsSample
//
//  Created by Evan Tu on 7/30/21.
//

import Foundation
import Charts
import CoreData

struct Transaction {
    
    var week: String
    var day: Double
    var calories: Double
    
    static func dataEntriesForWeek(_ week: String, _ transactions: [Transaction]) -> [ChartDataEntry] {
        let yt = transactions.filter { week == $0.week }
        
        return yt.map { ChartDataEntry(x: $0.day, y: $0.calories) }
    }
    
    static var days: [String] = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    
    static func allTransactions(starting: Int64, ending: Int64, workingDate: Date) -> [Transaction] {

        let fetchProgress: NSFetchRequest<Progress> = Progress.getAll()
        fetchProgress.predicate = NSPredicate(format: "progressDate >= \(starting) and progressDate <= \(ending)")

        let results = try? PersistenceController.shared.container.viewContext.fetch(fetchProgress)

            let progressArray = results!

            let dateToday = workingDate

            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"

            let dateInit: Date

            if dateToday.dayOfWeek()! == "Sunday" {
                dateInit = dateToday
            } else {
                dateInit = dateToday.previous(.sunday)
            }

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy/MM/dd"

            let startingDate = dateFormatterPrint.string(from: dateInit).replacingOccurrences(of: "/", with: "")


            var finalTransactionArr: Array<Transaction> = Array(repeating: Transaction(week: startingDate, day: 0, calories: 0), count: 7)

            for i in 0...6 {

                var cal: Double = 0

                for x in progressArray {
                    if i == 0 && x.day == "Sunday" {
                        cal = Double(x.calories)
                    }
                    if i == 1 && x.day == "Monday" {
                        cal = Double(x.calories)
                    }
                    if i == 2 && x.day == "Tuesday" {
                        cal = Double(x.calories)
                    }
                    if i == 3 && x.day == "Wednesday" {
                        cal = Double(x.calories)
                    }
                    if i == 4 && x.day == "Thursday" {
                        cal = Double(x.calories)
                    }
                    if i == 5 && x.day == "Friday" {
                        cal = Double(x.calories)
                    }
                    if i == 6 && x.day == "Saturday" {
                        cal = Double(x.calories)
                    }
                }

                finalTransactionArr[i] = Transaction(week: startingDate, day: Double(i), calories: cal)
            }


//            for x in finalTransactionArr {
//                print(x)
//            }


            return finalTransactionArr
    }
}

