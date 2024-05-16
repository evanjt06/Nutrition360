//
//  FoodListRowItem.swift
//  Project17
//
//  Created by Evan Tu on 7/18/21.
//

import SwiftUI

struct FoodListRowItem: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    var food: String
    
    @State private var foods: GenericFood = GenericFood(text: "", parsed: [])
    @State private var carbs = 0.0
    @State private var protein = 0.0
    @State private var fat = 0.0
    @State private var fiber = 0.0
    @State private var calories = 0.0
    @State private var imageURL = ""
   
    @ObservedObject var observer = Observer()
    
    @Binding var mealType: String
    
    @Binding var showFoodPicker: Bool
    
    @Binding var totalCalories: Double
    
    var date: Date
    
    var body: some View {
        
        return AnyView(VStack {
        
            ScrollView {
            if imageURL != "" {
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: imageURL)!) {
                        Text("loading...")
                    }
                    .frame(maxWidth: geometry.size.width)
                }.frame(height: 200)
               
            }
            Text("\(food.capitalized)")
                .font(Font.system(size: 34, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
            
            Spacer()
            
           
                VStack {
                    Text("Carbs: \(String(format: "%.2f", carbs)) g")
                        .padding()
                        .frame(width: 300, height: 42)
                        .background(Color.blue)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    Text("Protein: \(String(format: "%.2f", protein)) g")
                        .padding()
                        .frame(width: 300, height: 42)
                        .background(Color.blue)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    Text("Fat: \(String(format: "%.2f", fat)) g")
                        .padding()
                        .frame(width: 300, height: 42)
                        .background(Color.blue)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    Text("Fiber: \(String(format: "%.2f", fiber)) g")
                        .padding()
                        .frame(width: 300, height: 42)
                        .background(Color.blue)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    Text("Calories: \(String(format: "%.2f", calories)) cal")
                        .padding()
                        .frame(width: 300, height: 42)
                        .background(Color.blue)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    
                    Button("Select this food") {
                        
                        print("the mealType is: \(mealType)")

                        let foodData = Food(context: viewContext)
                        foodData.foodName = NSString(string: foods.text)
                        foodData.foodCalories = NSNumber(value: self.calories)
                        foodData.type = NSString(string: mealType)
                        foodData.date = date
                        
                        do {
                            try self.viewContext.save()

                            print("SAVED")
                        } catch {
                            print("FoodListRowItem (103A) - \(error.localizedDescription)")
                            
                            do {
                                try self.viewContext.save()
                                
                                print("i guess it worked?")
                            } catch {
                                print("FoodListRowItem (103B) - \(error.localizedDescription)")
                            }
                        }
                        
                        self.totalCalories += calories
                        self.showFoodPicker = false
                    }
                    .padding()
                    .frame(width: 300, height: 52)
                    .background(Color.purple)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                }.padding()
            
            
            Spacer()
                
            }
        })
      
        .onReceive(self.observer.$enteredForeground) { _ in
                
            
                Api().getFoods(food: food, completion: { foods in
                    
                   self.foods = foods
                    
                    if let parsed = foods.parsed {
                        
                        
                        
                        if parsed.count != 0 {
                            self.carbs = parsed[0].food.nutrients.carbs ?? 0.0
                            self.protein = parsed[0].food.nutrients.protein ?? 0.0
                            self.fat = parsed[0].food.nutrients.fat ?? 0.0
                            self.fiber = parsed[0].food.nutrients.fiber ?? 0.0
                            self.calories = parsed[0].food.nutrients.kcal ?? 0.0
                           self.imageURL = parsed[0].food.image ?? ""
                        }
                        
                    }
                    
                    if let parsed2 = foods.hints {
                        
                        
                        
                        if parsed2.count != 0 {
                            self.carbs = parsed2[0].food.nutrients.carbs ?? 0.0
                            self.protein = parsed2[0].food.nutrients.protein ?? 0.0
                            self.fat = parsed2[0].food.nutrients.fat ?? 0.0
                            self.fiber = parsed2[0].food.nutrients.fiber ?? 0.0
                            self.calories = parsed2[0].food.nutrients.kcal ?? 0.0
                           self.imageURL = parsed2[0].food.image ?? ""
                        }
                        
                    }
               })
           }
        
    }
}

class Observer: ObservableObject {

    @Published var enteredForeground = true

    init() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }

    @objc func willEnterForeground() {
        enteredForeground.toggle()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
