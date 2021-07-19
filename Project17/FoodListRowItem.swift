//
//  FoodListRowItem.swift
//  Project17
//
//  Created by Evan Tu on 7/18/21.
//

import SwiftUI

struct FoodListRowItem: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var food: String
    
    @State private var foods: GenericFood = GenericFood(text: "", parsed: [])
    @State private var carbs = 0.0
    @State private var protein = 0.0
    @State private var fat = 0.0
    @State private var fiber = 0.0
    @State private var calories = 0.0
    @State private var imageURL = ""
   
    @ObservedObject var observer = Observer()
    
    var body: some View {
        
        print(imageURL)
    
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
        //                self.result = ""
        //                self.selectedImage = nil
        //                self.showingImagePicker = false
        //                self.image = nil
        //                self.confirmUseThisFood = false
        //                self.originalResult = ""
                        
                        print("hi")
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
               print("App entered foreground!") // do stuff here
            
                Api().getFoods(food: food, completion: { foods in
                    
                   self.foods = foods

                   self.carbs = foods.parsed[0].food.nutrients.carbs
                   self.protein = foods.parsed[0].food.nutrients.protein
                   self.fat = foods.parsed[0].food.nutrients.fat
                    self.fiber = foods.parsed[0].food.nutrients.fiber ?? 0.0
                   self.calories = foods.parsed[0].food.nutrients.kcal
                   self.imageURL = foods.parsed[0].food.image ?? ""
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
