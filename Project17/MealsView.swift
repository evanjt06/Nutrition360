//
//  MealsView.swift
//  Project17
//
//  Created by Evan Tu on 7/8/21.
//

import SwiftUI
import CoreData

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
    
    var computedTotalCalories: String {
        
//        delete records:
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Progress")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        let container = PersistenceController.shared.container
//        do {
//            try container.viewContext.execute(deleteRequest)
//        } catch let error as NSError {
//            // TODO: handle the error
//        }
        
        var count = 0.0

        for x in data {
            if dateCheckValid(data: x.date) {
                count += Double(x.foodCalories)
            }
        }

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy/MM/dd"
        let reformattedDateNum = NSNumber(value: Int(dateFormatterPrint.string(from: date).replacingOccurrences(of: "/", with: ""))!)

        let progress: Progress
        let fetchProgress: NSFetchRequest<Progress> = Progress.getAll()
        fetchProgress.predicate = NSPredicate(format: "progressDate = %@", reformattedDateNum)

        let results = try? viewContext.fetch(fetchProgress)
        if results?.count == 0 {
            // insertion
            print("insert")
            progress = Progress(context: viewContext)
        } else {
            // update
            print("update")
            progress = results?.first ?? Progress(context: viewContext)
        }

        progress.calories = NSNumber(value: Double(count))
        progress.day = NSString(string: date.dayOfWeek()!)
        progress.progressDate = reformattedDateNum

        do {
           try self.viewContext.save()

           print("PROGRESS SAVED")
       } catch {
           print("MealsView 96 - \(error.localizedDescription)")
       }
        
        return Int(exactly: count) == nil ?  String(format: "%.2f", count) : "\(Int(count))"
    }

    var body: some View {
                     
        var currentMealType = ""
        
            return List {
               
                Section {
                    
                    HStack {
                    Text("Breakfast")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    Spacer()
                    Image(systemName: "sunrise")
                        .scaleEffect(1.5)
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.purple)
                            .cornerRadius(8)
                            .frame(height: 40)
                            .padding(.horizontal)

                        Text("Add breakfast items")
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
                                NavigationLink(destination: FoodNutritionView(food: "\(x.foodName)".firstCapitalized)) {
                                    Text("\(x.foodName)".firstCapitalized)
                                        .font(Font.system(size: 18, design: .rounded))
                                    Spacer()
                                    
                                    Text(Int(exactly: x.foodCalories) == nil ?  "\(Double(x.foodCalories), specifier: "%.2f") cal" : "\(Int(x.foodCalories)) cal")
                                        .font(Font.system(size: 18, weight: .bold, design: .rounded))
                                    
                                }
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
                        Text("Lunch")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                        Spacer()
                        Image(systemName: "sun.min")
                            .scaleEffect(1.5)
                    }
                    ZStack {
                        Rectangle()
                            .fill(Color.purple)
                            .cornerRadius(8)
                            .frame(height: 40)
                            .padding(.horizontal)

                        Text("Add lunch items")
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
                                NavigationLink(destination: FoodNutritionView(food: "\(x.foodName)".firstCapitalized)) {
                                    Text("\(x.foodName)".firstCapitalized)
                                        .font(Font.system(size: 18, design: .rounded))
                                    Spacer()
                                    Text(Int(exactly: x.foodCalories) == nil ? "\(Double(x.foodCalories), specifier: "%.2f") cal" : "\(Int(x.foodCalories)) cal")
                                        .font(Font.system(size: 18, weight: .bold, design: .rounded))
                                    
                                }
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
                        Text("Dinner")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                        Spacer()
                        Image(systemName: "sunset")
                            .scaleEffect(1.5)
                    }
                    ZStack {
                        
                            Rectangle()
                                .fill(Color.purple)
                                .cornerRadius(8)
                                .frame(height: 40)
                                .padding(.horizontal)

                                Text("Add dinner items")
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
                                NavigationLink(destination: FoodNutritionView(food: "\(x.foodName)".firstCapitalized)) {
                                    Text("\(x.foodName)".firstCapitalized)
                                        .font(Font.system(size: 18, design: .rounded))
                                    Spacer()
                                    Text(Int(exactly: x.foodCalories) == nil ?  "\(Double(x.foodCalories), specifier: "%.2f") cal" : "\(Int(x.foodCalories)) cal")
                                        .font(Font.system(size: 18, weight: .bold, design: .rounded))
                                    
                                }
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
                        Text("Snacks")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                        Spacer()
                        Image(systemName: "drop")
                            .scaleEffect(1.5)
                    }
                    ZStack {
                        Rectangle()
                            .fill(Color.purple)
                            .cornerRadius(8)
                            .frame(height: 40)
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
                                NavigationLink(destination: FoodNutritionView(food: "\(x.foodName)".firstCapitalized)) {
                                    Text("\(x.foodName)".firstCapitalized)
                                        .font(Font.system(size: 18, design: .rounded))
                                    Spacer()
                                    Text(Int(exactly: x.foodCalories) == nil ?  "\(Double(x.foodCalories), specifier: "%.2f") cal" : "\(Int(x.foodCalories)) cal")
                                        .font(Font.system(size: 18, weight: .bold, design: .rounded))
                                    
                                }
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
                        Text("Total Calories: \(self.computedTotalCalories) calories")
                        Spacer()
                    }
                    
                    if UserDefaults.standard.string(forKey: "gender") == "Male" {
                            if Double(self.computedTotalCalories)! < 2500.0 {
                                Text("Recommended daily calorie intake: ").font(Font.system(size: 16, weight: .regular, design: .rounded)) + Text("Not Met").foregroundColor(.red).font(Font.system(size: 16, weight: .regular, design: .rounded))
                            } else if Double(self.computedTotalCalories)! > 4000.0 {
                                Text("Recommended daily calorie intake: ").font(Font.system(size: 16, weight: .regular, design: .rounded)) + Text("Exceeded limit").foregroundColor(.red).font(Font.system(size: 16, weight: .regular, design: .rounded))
                            } else {
                                Text("Recommended daily calorie intake: ") + Text("Met").foregroundColor(.green)
                            }
                    }
                    
                    if UserDefaults.standard.string(forKey: "gender") == "Female" {
                        if  Double(self.computedTotalCalories)! < 2000.0  {
                            Text("Recommended daily calorie intake: ").font(Font.system(size: 16, weight: .regular, design: .rounded)) + Text("Not Met").foregroundColor(.red).font(Font.system(size: 16, weight: .regular, design: .rounded))
                        } else if Double(self.computedTotalCalories)! > 3500.0 {
                            Text("Recommended daily calorie intake: ").font(Font.system(size: 16, weight: .regular, design: .rounded)) + Text("Exceeded limit").foregroundColor(.red).font(Font.system(size: 16, weight: .regular, design: .rounded))
                        } else {
                            Text("Recommended daily calorie intake: ") + Text("Met").foregroundColor(.green)
                        }
                    }
                }
            
            }
            .listStyle(InsetGroupedListStyle())
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
