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
        }
    }
}


struct ContentView: View {
    
    @State private var selectedIndex: Int = 0

        var selectedItem: BottomBarItem {
            items[selectedIndex]
        }
    
    @State private var hasSceneOnboardingScreen = true
    
    @State private var name = ""
    @State private var gender = ""
    
    @State private var showingIntroPopup = false
    
    var body: some View {

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
                
                
                
                withAnimation {
                    self.hasSceneOnboardingScreen = true
                }
            }
            a.animationDidEnd = {

            }
            a.didGoToLastPage = {
            }
            return AnyView(a)
            
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
                                Image("screen 1")
                                    .resizable()
                                    .aspectRatio(contentMode: ContentMode.fit)
                                    .frame(width: 100, height: 100)

                                Text("Hi Evan!")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)

                                Text("In this example floats are set to disappear after 2 seconds. Tap the toasts to dismiss or just open some other popup - previous one will be dismissed. This popup will only be closed if you tap the button.")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                                    .lineLimit(nil)

                                Spacer()

                                Button(action: {
                                    self.showingIntroPopup = false
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
                            .padding(EdgeInsets(top: 70, leading: 20, bottom: 40, trailing: 20))
                            .frame(width: 300, height: 400)
                    .background(Color.orange)
                            .cornerRadius(10.0)
                            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
                    }
            
            
            )}
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
