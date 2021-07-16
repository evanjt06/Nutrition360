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
                    print("asd")
                    
                    self.showFoodPicker.toggle()
                }
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
                    print("asd")
                    
                    self.showFoodPicker.toggle()
                }
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
                    print("asd")
                    
                    self.showFoodPicker.toggle()
                }
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
                    print("asd")
                    
                    self.showFoodPicker.toggle()
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Text("Total Calories: \(calories) cal")
                    Spacer()
                }
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
