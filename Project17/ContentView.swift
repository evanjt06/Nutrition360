//
//  ContentView.swift
//  Project17
//
//  Created by Evan Tu on 7/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var date = Date()
    
    var body: some View {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
         
        
        return TabView {
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
            
        }.accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
