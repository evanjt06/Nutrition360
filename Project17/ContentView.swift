//
//  ContentView.swift
//  Project17
//
//  Created by Evan Tu on 7/7/21.
//

import SwiftUI
import ConcentricOnboarding
import SwiftUICharts
import ExytePopupView
import BottomBar_SwiftUI
    
let items: [BottomBarItem] = [
    BottomBarItem(icon: "rectangle.split.3x3", title: "Meals", color: .purple),
    BottomBarItem(icon: "chart.bar.xaxis", title: "Progress", color: .pink),
]

struct BasicView_1: View {
    
    @State private var date = Date()
    
    var body: some View {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return VStack {
            MealsView(date: $date)
                .navigationBarTitle(

                    Text("\(dateFormatter.string(from: date))")

                )
                .navigationBarItems(trailing:

                                        HStack {
                                            DatePicker("", selection: $date, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                            .labelsHidden()
                                        }
                )
        }
    }
}

struct BasicView_2: View {
    
    var body: some View {
      
        return VStack {
            ProgressView()
                .navigationBarTitle("Progress")
                .navigationBarItems(trailing: EmptyView())
        }
    }
}


struct ContentView: View {
   
    init() {
        let defaults = UserDefaults.standard
        
        self.hasSceneOnboardingScreen = defaults.bool(forKey: "hasSeenOnboarding")
        self.showingIntroPopup = defaults.bool(forKey: "showingIntroPopUp")
        self.name = defaults.string(forKey: "name") ?? ""
        self.gender = defaults.string(forKey: "gender") ?? ""
        
    }
    
    @State private var selectedIndex: Int = 0

        var selectedItem: BottomBarItem {
            items[selectedIndex]
        }
    
    @State private var hasSceneOnboardingScreen: Bool
    @State private var showingIntroPopup: Bool
    @State private var name: String
    @State private var gender: String
    
    @State private var showAlert = false
    
    @State private var fakeAlertNeverToBeTouched = false
    
    var body: some View {
        
        print(hasSceneOnboardingScreen, showingIntroPopup)

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
                
                print("done!")
                
                if self.name == "" || self.gender == "" {
                    showAlert = true
                    return
                }
                
                // assign to user defaults now
                let defaults = UserDefaults.standard
                defaults.set(self.name, forKey: "name")
                defaults.set(self.gender, forKey: "gender")
                defaults.set(true, forKey: "hasSeenOnboarding")
                
                showingIntroPopup = true
                hasSceneOnboardingScreen = true
            }
            a.animationDidEnd = {

            }
            a.didGoToLastPage = {
            }
            return AnyView(
                a
            ).alert(isPresented: $showAlert) {
                Alert(title: Text("Nutrition360 - Error"), message: Text("You must fill out your name and biological sex."), dismissButton: .default(Text("OK")))
            }
            
        } else {
            return AnyView(
                
                ZStack {
                    NavigationView {
                        VStack {
                            if (selectedIndex == 0) {
                                       BasicView_1()
                            }
                            
                            if (selectedIndex == 1) {
                                BasicView_2()
                            }
                                           
                                       BottomBar(selectedIndex: $selectedIndex, items: items)
                                   }
                    }

                }
                .popup(isPresented: $showingIntroPopup, type: .`default`, closeOnTap: false) {
                        VStack(spacing: 10) {
                            Text("Hi \(self.name)!")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)

                                Text("This app allows you to add foods you have eaten in four sections: Breakfast, Lunch, Dinner, and Snacks. Your meals will be tracked everyday, and you may also choose and pick the day on the calendar. Additionally, you have the ability to take a picture of your food and the app will insert into the food log. You may also use the voice option to speak into the mic to insert your food. Nutritional details will be provided for each food you input. You can also look at your progress (progression in caloric intake) over a prolonged period of time. Happy tracking!")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .lineLimit(nil)

                                Spacer()

                                Button(action: {
                                    let defaults = UserDefaults.standard
                                    defaults.set(false, forKey: "showingIntroPopUp")
                                    
                                    showingIntroPopup = false
                                }) {
                                    Text("Got it")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                                .frame(width: 100, height: 40)
                                .background(Color.white)
                                .cornerRadius(20.0)
                            }
                            .padding(EdgeInsets(top: 50, leading: 20, bottom: 40, trailing: 20))
                            .frame(width: 300, height: 400)
                            .background(Color.orange)
                            .cornerRadius(10.0)
                            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
                    }
            
            
            ).alert(isPresented: $fakeAlertNeverToBeTouched) {
                Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
            }}
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
