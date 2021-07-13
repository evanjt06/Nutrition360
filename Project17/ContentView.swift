//
//  ContentView.swift
//  Project17
//
//  Created by Evan Tu on 7/7/21.
//

import SwiftUI
import ConcentricOnboarding

struct ContentView: View {
    
    @State private var hasSceneOnboardingScreen = false
    @State private var date = Date()
    
    var body: some View {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none

        if !hasSceneOnboardingScreen {
           
            let pages = (0...3).map { i in
                AnyView(PageView(title: MockData.title, imageName: MockData.imageNames[i], header: MockData.headers[i], content: MockData.contentStrings[i], textColor: MockData.textColors[i]))
            }

            var a = ConcentricOnboardingView(pages: pages, bgColors: MockData.colors)

    //        a.didPressNextButton = {
    //            a.goToPreviousPage(animated: true)
    //        }
            a.insteadOfCyclingToFirstPage = {
                print("do your thing")
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

