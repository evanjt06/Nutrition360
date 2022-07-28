//
//  ContentView.swift
//  Project17
//
//  Created by Evan Tu on 7/7/21.
//

import SwiftUI
import ConcentricOnboarding
//import SwiftUICharts
import ExytePopupView
import BottomBar_SwiftUI
    

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff


        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

struct BasicView_1: View {
    
    @State private var date = Date()
    
    var body: some View {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return VStack {
            MealsView(date: $date)
                .navigationBarTitle(

                    Text("\(dateFormatter.string(from: date))")

                )
                .navigationBarItems(trailing:

                                        HStack {
                                            DatePicker("", selection: $date, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                            .labelsHidden()
                                        }
                )
        }
    }
}

struct BasicView_2: View {
    
    @State var dateToday = Date.today()
    
    var computedWeekRange: (String, String, Int64, Int64) {
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"

        var startOfWeek: String
        var endOfWeek: String

        let temporaryDate: Date
        let tempDate2 :Date
        
        if self.dateToday.dayOfWeek()! == "Sunday" {
            startOfWeek = df.string(from: dateToday)
            
            temporaryDate = self.dateToday
        } else {
            let xx = self.dateToday.previous(.sunday)
            startOfWeek = (df.string(from: xx))
            
            temporaryDate = xx
        }
        if self.dateToday.dayOfWeek()! == "Saturday" {
            endOfWeek = df.string(from: dateToday)
            
            tempDate2 = self.dateToday
        } else {
            let xx2 = self.dateToday.next(.saturday)
            endOfWeek = (df.string(from: xx2))
            
            tempDate2 = xx2
        }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy/MM/dd"
        
        let startingDate = Int64(dateFormatterPrint.string(from: temporaryDate).replacingOccurrences(of: "/", with: ""))!
        let endingDate = Int64(dateFormatterPrint.string(from: tempDate2).replacingOccurrences(of: "/", with: ""))!
        
        return (startOfWeek, endOfWeek, startingDate, endingDate)
        
    }
    
    var body: some View {
        
        return VStack {
            ProgressView(weekA: self.computedWeekRange.0, weekB: self.computedWeekRange.1, startingVal: self.computedWeekRange.2, endingVal: self.computedWeekRange.3, workingDate: dateToday)
                .navigationBarTitle("Progress")
                .navigationBarItems(leading:
                                        Button(action: {
                                              
                                            self.dateToday = Calendar.current.date(byAdding: .day, value: -7, to: dateToday)!
                                         
                                        }) {
                                            Image(systemName: "chevron.left")
                                            Text("Previous Week")
                                        }.accentColor(.red)
                                        .foregroundColor(.red)
                                    , trailing: Button(action: {
                                        self.dateToday = Calendar.current.date(byAdding: .day, value: 7, to: dateToday)!
                                       
                                    }) {
                        Text("Next Week")
                        Image(systemName: "chevron.right")
                    }.accentColor(.red).foregroundColor(.red))
        }
    }

}


struct ContentView: View {
   
    init() {
        let defaults = UserDefaults.standard
        
        self.hasSceneOnboardingScreen = defaults.bool(forKey: "hasSeenOnboarding")
        self.showingIntroPopup = defaults.bool(forKey: "showingIntroPopUp")

    }
    
    @State private var selectedIndex: Int = 0
    
    @State private var hasSceneOnboardingScreen: Bool
    @State private var showingIntroPopup: Bool
    
    @State private var fakeAlertNeverToBeTouched = false
    
    var body: some View {
        
        print(hasSceneOnboardingScreen, showingIntroPopup)

        if !hasSceneOnboardingScreen {
           
            let pages = [
                AnyView(Page1())
            ]

            var a = ConcentricOnboardingView(pages: pages, bgColors: [
                "F38181",
                "FCA903"
            ].map{ Color(hex: $0) })

    //        a.didPressNextButton = {
    //            a.goToPreviousPage(animated: true)
    //        }
            a.insteadOfCyclingToFirstPage = {
                
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "hasSeenOnboarding")
                                
                showingIntroPopup = true
                hasSceneOnboardingScreen = true
            }
            a.animationDidEnd = {

            }
            a.didGoToLastPage = {
            }
            return AnyView(
                a
            )
            
        } else {
            return AnyView(
                
                ZStack {
                    
//                        VStack {
//                            if (selectedIndex == 0) {
//                                       BasicView_1()
//                            }
//
//                            if (selectedIndex == 1) {
//                                BasicView_2()
//                            }
//
//                                       BottomBar(selectedIndex: $selectedIndex, items: items)
//                                   }
                        
                        TabView {
                            
                            NavigationView {
                                BasicView_1()
                                    .navigationBarTitle("Page One")
                            }
                            .tabItem {
                                Image(systemName: "rectangle.split.3x3")
                                Text("Meals")
                            }
                            
                            NavigationView {
                                BasicView_2()
                                    .navigationBarTitle("Page Two")
                            }
                                    .tabItem {
                                        Image(systemName: "chart.bar.xaxis")
                                        Text("Progress")
                                }
                            
                        }.accentColor(.red)
                    

                }
                .popup(isPresented: $showingIntroPopup, type: .`default`, closeOnTap: false) {
                        VStack(spacing: 10) {
                            Text("Welcome!")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)

                                Text("Nutrition360 allows you to add foods you have eaten in four sections: Breakfast, Lunch, Dinner, and Snacks. Your meals will be tracked everyday, and you may also choose and pick the day on the calendar. Additionally, you have the ability to take a picture of your food and the app will insert into the food log. You may also use the voice option to speak into the mic to insert your food. Nutritional details will be provided for each food you input. You can also look at your progress (progression in caloric intake) over a prolonged period of time. Happy tracking!")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .lineLimit(nil)

                                Spacer()

                                Button(action: {
                                    let defaults = UserDefaults.standard
                                    defaults.set(false, forKey: "showingIntroPopUp")
                                    
                                    showingIntroPopup = false
                                }) {
                                    Text("Got it")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                                .frame(width: 100, height: 40)
                                .background(Color.white)
                                .cornerRadius(20.0)
                            }
                            .padding(EdgeInsets(top: 50, leading: 20, bottom: 40, trailing: 20))
                            .frame(width: 300, height: 400)
                            .background(Color.orange)
                            .cornerRadius(10.0)
                            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
                    }
            
            
            )

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

