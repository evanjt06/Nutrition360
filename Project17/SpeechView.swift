//
//  SpeechView.swift
//  Project17
//
//  Created by Evan Tu on 7/26/21.
//

import SwiftUI
import SwiftSpeech

struct SpeechView: View {
    
    
    @State private var text = ""
    @State private var autocompletedFoods: [String] = []
    
    @Binding var mealType: String
    @Binding var showFoodPicker: Bool
    @Binding var totalCalories: Double
    var date: Date
    
    @State private var choice: Bool = true
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        let sessionConfiguration: SwiftSpeech.Session.Configuration = SwiftSpeech.Session.Configuration(locale: .current)
        
        return VStack(spacing: 10.0) {
            
            HStack {
                Button(action: {
                    
                }) {
                
                    Image(systemName: "x.circle")
                        .scaleEffect(1.5)
                        .padding()
                
                    
                }.hidden()
                Spacer()
                
              Text(choice ? "Tap button once to speak" : "Tap button again to search")
                  .font(.system(size: 20, weight: .bold, design: .rounded))
                  .multilineTextAlignment(.center)
                
                Spacer()
                Button(action: {
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                  
                    Image(systemName: "x.circle.fill")
                        .scaleEffect(1.5)
                        .padding()
                        .accentColor(colorScheme == .dark ? .white : .black)
                }
            }
            
            
            Text(text)
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .padding(.bottom, 20)
            
            SwiftSpeech.RecordButton()
                .swiftSpeechToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: .spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0))
                .onRecognizeLatest(update: $text)
                .onStopRecording { session in
                    print("stopped recording...")
                    choice = true
                    
                    // use text and use the api now
                    Api().getAutocompleteList(food: text) { foods in
                        
                        self.autocompletedFoods = foods
                        
                        print("done \(autocompletedFoods)")
                        
                    }
                }
                .onStartRecording { session in
                    choice = false
                }
            
            Spacer()
                .frame(height: 5)
            
            if autocompletedFoods.count == 0 {
                Text("No results found...")
            }
                        
            if autocompletedFoods.count != 0 {
                NavigationView {
                    List(autocompletedFoods, id: \.self) { food in
                        NavigationLink(destination: FoodListRowItem(food: food, mealType: $mealType, showFoodPicker: $showFoodPicker, totalCalories: $totalCalories, date: date)) {
                            Text(food)
                        }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                }
                    .navigationBarTitle("")
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                }
            }
            
            Spacer()
            
        }
        .padding(.top)
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
}
