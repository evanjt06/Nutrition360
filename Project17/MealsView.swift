//
//  MealsView.swift
//  Project17
//
//  Created by Evan Tu on 7/8/21.
//

import SwiftUI

struct MealsView: View {
    
    @State private var calories = 0
    @State private var showFoodPicker = false
    
    var body: some View {
        List {
            Section {
                Text("Breakfast")
                    .font(.system(size: 30, weight: .heavy, design: .default))
                Button("Add Food") {
                    print("asd")
                    
                    self.showFoodPicker.toggle()
                }
                .font(.system(size: 15, weight: .heavy, design: .default))
                .foregroundColor(.red)
            }
            Section {
                Text("Lunch")
                    .font(.system(size: 30, weight: .heavy, design: .default))
                Button("Add Food") {
                    print("asd")
                    
                    self.showFoodPicker.toggle()
                }
                .font(.system(size: 15, weight: .heavy, design: .default))
                .foregroundColor(.red)
            }
            Section {
                Text("Dinner")
                    .font(.system(size: 30, weight: .heavy, design: .default))
                Button("Add Food") {
                    print("asd")
                    
                    self.showFoodPicker.toggle()
                }
                .font(.system(size: 15, weight: .heavy, design: .default))
                .foregroundColor(.red)
            }
            Section {
                Text("Snacks")
                    .font(.system(size: 30, weight: .heavy, design: .default))
                Button("Add Food") {
                    print("asd")
                    
                    self.showFoodPicker.toggle()
                }
                .font(.system(size: 15, weight: .heavy, design: .default))
                .foregroundColor(.red)
            }
            
            Section {
                Text("Calories: \(calories) cal")
                Text("Daily goal reached: ") + Text("Almost there!").foregroundColor(.red)
                NavigationLink("See Nutrition Chart...", destination: Text("chart here"))
            }
            
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $showFoodPicker) {
            FoodPicker()
        }
    }
}

struct MealsView_Previews: PreviewProvider {
    static var previews: some View {
        MealsView()
    }
}
