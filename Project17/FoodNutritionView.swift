//
//  FoodNutritionView.swift
//  NutritionGram
//
//  Created by Evan Tu on 7/29/21.
//

import SwiftUI

struct FoodNutritionView: View {

    var food: String
    @ObservedObject var observer = Observer()
    
    @State private var carbs = 0.0
    @State private var protein = 0.0
    @State private var fat = 0.0
    @State private var fiber = 0.0
    @State private var calories = 0.0
    
    var body: some View {
        
        let buildFitness = Legend(color: .purple, label: "Fiber", order: 4)
        let fatBurning = Legend(color: .blue, label: "Fat", order: 3)
        let warmUp = Legend(color: .orange, label: "Protein", order: 2)
        let low = Legend(color: .red, label: "Carbs", order: 1)

        let points: [DataPoint] = [
            .init(value: carbs, label: "\(String(format: "%.2f", carbs)) g", legend: low),
            .init(value: protein, label: "\(String(format: "%.2f", protein)) g", legend: warmUp),
            .init(value: fat, label: "\(String(format: "%.2f", fat)) g", legend: fatBurning),
            .init(value: fiber, label: "\(String(format: "%.2f", fiber)) g", legend: buildFitness),
        ]
        
        
        VStack {
            Text(food)
                .font(Font.system(size: 40, weight: .bold, design: .rounded))

            Spacer()
                .frame(height: 10)

            Section(header: Text("\(String(format: "%.2f", calories)) calories").font(.headline).foregroundColor(.gray)) {
                BarChartView(dataPoints: points)
            }

        }
        .padding()
        .onReceive(self.observer.$enteredForeground) { _ in
                
            
                Api().getFoods(food: food, completion: { foods in
                    
                    if let parsed = foods.parsed {
                        
                        
                        
                        if parsed.count != 0 {
                            self.carbs = parsed[0].food.nutrients.carbs ?? 0.0
                            self.protein = parsed[0].food.nutrients.protein ?? 0.0
                            self.fat = parsed[0].food.nutrients.fat ?? 0.0
                            self.fiber = parsed[0].food.nutrients.fiber ?? 0.0
                            self.calories = parsed[0].food.nutrients.kcal ?? 0.0
                        }
                        
                    }
                    
                    if let parsed2 = foods.hints {
                        
                        
                        if parsed2.count != 0 {
                            self.carbs = parsed2[0].food.nutrients.carbs ?? 0.0
                            self.protein = parsed2[0].food.nutrients.protein ?? 0.0
                            self.fat = parsed2[0].food.nutrients.fat ?? 0.0
                            self.fiber = parsed2[0].food.nutrients.fiber ?? 0.0
                            self.calories = parsed2[0].food.nutrients.kcal ?? 0.0
                        }
                        
                    }
               })
           }

    }
}
