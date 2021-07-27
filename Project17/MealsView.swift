//
//  MealsView.swift
//  Project17
//
//  Created by Evan Tu on 7/8/21.
//

import SwiftUI

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

struct MealsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Food.getAll()) var data: FetchedResults<Food>
 
    @State private var calories = 0.0
    @State private var showFoodPicker = false
    
    @Binding var date: Date
    
    var computedTotalCalories: Double {
        var count = 0
        
        for x in data {
            if dateCheckValid(data: x.date) {
                count += Int(x.foodCalories)
            }
        }
        
        return Double(count)
    }

    var body: some View {
                     
        var currentMealType = ""
        
            return List {
                Section {
                    Text("Breakfast")
                        .font(.system(size: 30, weight: .heavy, design: .default))
                    ZStack {
                        Rectangle()
                            .fill(Color.purple)
                            .cornerRadius(8)
                            .frame(height: 52)
                            .padding(.horizontal)

                        Text("Add breakfast")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        
                        
                        currentMealType = "Breakfast"
                        
                        if currentMealType != "" {
                            showFoodPicker = true
                        }
                        
                    }
                    
                    ForEach(self.data) { x in
                        
                        if x.type == "Breakfast" && dateCheckValid(data: x.date) {
                            HStack {
                                Text("\(x.foodName)".firstCapitalized)
                                    .font(Font.system(size: 18, design: .rounded))
                                    
                                Spacer()
                                Text("\(x.foodCalories.intValue) cal")
                                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        let di = data[indexSet.first!]
                        
                        self.viewContext.delete(di)
                        
                        do {
                            try self.viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                    
                    
                }
                Section {
                    Text("Lunch")
                        .font(.system(size: 30, weight: .heavy, design: .default))
                  
                    ZStack {
                        Rectangle()
                            .fill(Color.purple)
                            .cornerRadius(8)
                            .frame(height: 52)
                            .padding(.horizontal)

                        Text("Add lunch")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        
                        
                        currentMealType = "Lunch"
                        
                        if currentMealType != "" {
                            showFoodPicker = true
                        }
                    }
                    
                    ForEach(self.data) { x in
                        if x.type == "Lunch"  && dateCheckValid(data: x.date) {
                            HStack {
                                Text("\(x.foodName)".firstCapitalized)
                                    .font(Font.system(size: 18, design: .rounded))
                                    
                                Spacer()
                                Text("\(x.foodCalories.intValue) cal")
                                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        let di = data[indexSet.first!]
                        
                        self.viewContext.delete(di)
                        
                        do {
                            try self.viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }
                Section {
                    Text("Dinner")
                        .font(.system(size: 30, weight: .heavy, design: .default))
                
                    ZStack {
                        
                            Rectangle()
                                .fill(Color.purple)
                                .cornerRadius(8)
                                .frame(height: 52)
                                .padding(.horizontal)

                                Text("Add dinner")
                                    .font(.headline)
                                    .foregroundColor(.white)
                    }
                    .onTapGesture {
                        currentMealType = "Dinner"
                        
                        if currentMealType != "" {
                            showFoodPicker = true
                        }
                        
                        
                    }
                
                    ForEach(self.data) { x in
                        if x.type == "Dinner" && dateCheckValid(data: x.date) {
                            HStack {
                                Text("\(x.foodName)".firstCapitalized)
                                    .font(Font.system(size: 18, design: .rounded))
                                    
                                Spacer()
                                Text("\(x.foodCalories.intValue) cal")
                                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        let di = data[indexSet.first!]
                        
                        self.viewContext.delete(di)
                        
                        do {
                            try self.viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }
                Section {
                    Text("Snacks")
                        .font(.system(size: 30, weight: .heavy, design: .default))
                    ZStack {
                        Rectangle()
                            .fill(Color.purple)
                            .cornerRadius(8)
                            .frame(height: 52)
                            .padding(.horizontal)

                        Text("Add snacks")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        
                        
                        currentMealType = "Snacks"
                        
                        if currentMealType != "" {
                            showFoodPicker = true
                        }
                        

                    }
                    
                    ForEach(self.data) { x in
                        if x.type == "Snacks" && dateCheckValid(data: x.date) {
                            HStack {
                                Text("\(x.foodName)".firstCapitalized)
                                    .font(Font.system(size: 18, design: .rounded))
                                    
                                Spacer()
                                Text("\(x.foodCalories.intValue) cal")
                                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        let di = data[indexSet.first!]
                        
                        self.viewContext.delete(di)
                        
                        do {
                            try self.viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("Total Calories: \(String(format: "%.2f", self.computedTotalCalories)) cal")
                        Spacer()
                    }
                }
            
            }
            .listStyle(PlainListStyle())
        .sheet(isPresented: $showFoodPicker) {
            FoodPicker(mealType: currentMealType, showFoodPicker: $showFoodPicker, totalCalories: $calories, date: date)
        }
         

    }
    
    func dateCheckValid(data: Date) -> Bool {
        
        if date.get(.day) == data.get(.day) {
            if date.get(.month) == data.get(.month) {
                if date.get(.year) == data.get(.year) {
                    return true
                }
            }
        }
        
        return false
    }
}

extension StringProtocol {
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
        
    }
}
