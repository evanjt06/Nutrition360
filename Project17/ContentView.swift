//
//  ContentView.swift
//  Project17
//
//  Created by Evan Tu on 7/7/21.
//

import SwiftUI
import ConcentricOnboarding
import SwiftUICharts

struct ContentView: View {
    
    @State private var hasSceneOnboardingScreen = false
    @State private var date = Date()
    
    @State private var name = ""
    @State private var gender = ""
    
    var body: some View {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none

        if !hasSceneOnboardingScreen {
           
            let pages = [
                AnyView(Page1()),
                AnyView(Page2(name: $name, gender: $gender)),
            ]

            var a = ConcentricOnboardingView(pages: pages, bgColors: [
                "F38181",
                "FCE38A",
                ].map{ Color(hex: $0) })

    //        a.didPressNextButton = {
    //            a.goToPreviousPage(animated: true)
    //        }
            a.insteadOfCyclingToFirstPage = {
                
                print(name,gender)
                
                withAnimation {
                    self.hasSceneOnboardingScreen = true
                }
            }
            a.animationDidEnd = {

            }
            a.didGoToLastPage = {
            }
            return AnyView(a)
            
        } else {
            return AnyView(TabView {
                NavigationView {
                    MealsView()
                        .navigationBarTitle("Meals - \(dateFormatter.string(from: date))")
                        .navigationBarItems(trailing: DatePicker("", selection: $date, displayedComponents: .date))
                        
                }.tag(0)
                .tabItem {
                    Image(systemName: "rectangle.split.3x3")
                    Text("Meals")
                }
                
                
                NavigationView {
                    ProgressView()
                    
                        .navigationBarTitle("Progress")
                }.tag(1)
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Progress")
                }
                
            }.accentColor(.red))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
