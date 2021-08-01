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
    
    var body: some View {
        
        let sessionConfiguration: SwiftSpeech.Session.Configuration = SwiftSpeech.Session.Configuration(locale: .current)
        
        return VStack(spacing: 35.0) {
            
            Text("Tap to speak and tap again when finished speaking.")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text(text)
                .font(.system(size: 25, weight: .bold, design: .rounded))
            SwiftSpeech.RecordButton()
                .swiftSpeechToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: .spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0))
                .onRecognizeLatest(update: $text)
                .onStopRecording { session in
                    print("stopped recording...")
                    
                    // use text and use the api now
                    Api().getAutocompleteList(food: text) { foods in
                        
                        self.autocompletedFoods = foods
                        
                        print("done \(autocompletedFoods)")
                        
                    }
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
