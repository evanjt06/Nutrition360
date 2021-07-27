//
//  FoodPicker.swift
//  Project17
//
//  Created by Evan Tu on 7/11/21.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct FoodPicker: View {
    
    @State var activeSheet: ActiveSheet?
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var sourceType: UIImagePickerController.SourceType?
    @State private var result = ""
    @State private var originalResult = ""
    @State private var image: Image?
    @State private var selectedImage: UIImage?
    
    @State private var confirmUseThisFood = false
    
    @State private var text = ""

    @State private var autocompletedFoods: [String] = []
    
    @State var mealType: String
    
    @Binding var showFoodPicker: Bool
    
    @Binding var totalCalories: Double
    
    @State var yesbuttonClicked = false
    
    var date: Date
    
    let model = Food101()
    
    var body: some View {
        
        if showFoodPicker == false {
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
        return VStack {
            
            if let image = image {

                VStack {

                    image
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            self.performImageClassify()
                        }
                    Text(self.result) .font(Font.system(size: 18, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                           .frame(height: 15)
                    
                    if self.confirmUseThisFood == false {
                        Button("Take another photo") {
                            
                            
                            self.result = ""
                            self.image = nil
                            self.selectedImage = nil
                            self.originalResult = ""
                            
                            activeSheet = .first
                        }
                        .padding()
                        .frame(width: 300, height: 52)
                        .background(Color.blue)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    }
                    
                    if self.confirmUseThisFood == true {
                        
                        if yesbuttonClicked == false {
                            HStack {
                                Button("No") {
                                    
                                    
                                    self.result = ""
                                    self.image = nil
                                    self.selectedImage = nil
                                    self.originalResult = ""
                                    self.confirmUseThisFood = false
                                    
                                    activeSheet = .first
                                }
                                .padding()
                                .frame(width: 150, height: 52)
                                .background(Color.red)
                                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Button("Yes") {
                                    
                                    
                                    let temp = self.originalResult.replacingOccurrences(of: "_", with: " ")

                                    Api().getAutocompleteList(food: temp) { foods in
                                        
                                        self.autocompletedFoods = foods
                                        
                                        yesbuttonClicked = true
                                    }
                                }
                                .padding()
                                .frame(width: 150, height: 52)
                                .background(Color.green)
                                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            }
                        } else {
                            
                            if autocompletedFoods.count == 0 {
                                Text("Sorry, but this food is currently not supported in our app.")
                                    .padding()
                                    .multilineTextAlignment(.center)
                            } else {
                            
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
                            
                        }
                        
                        
                    }

                }
//
            }
            
            else {
//
                VStack {
                    
                    Spacer()
                        .frame(height: 20)

                    HStack {
                       
                            VStack(alignment: .leading) {
                                Button(action: {
                                    self.sourceType = .camera
//                                    self.showingImagePicker.toggle()
                                    
                                    activeSheet = .first
                                }) {
                                    Image(systemName: "camera")
                                    Text("Scan food")  .multilineTextAlignment(.center)
                                }
                                .frame(width: UIScreen.screenWidth / 2.4)
                                .multilineTextAlignment(.center)
                            }
                            .padding(10)
                            .background(colorScheme == .dark ? Color.white : Color.black)
                            .cornerRadius(10)
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                            .onTapGesture {
                                self.sourceType = .camera
//                                self.showingImagePicker.toggle()
                                
                                activeSheet = .first
                            }
                            
                            VStack(alignment: .leading) {
                                Button(action: {
//                                    self.sourceType = .camera
//                                    self.showingImagePicker.toggle()
                                    
                                    activeSheet = .second
                                }) {
                                    Image(systemName: "waveform.circle")
                                    Text("Use voice")  .multilineTextAlignment(.center)
                                }
                                .frame(width: UIScreen.screenWidth / 2.4)
                                .multilineTextAlignment(.center)
                            }
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                            .onTapGesture {
                                self.sourceType = .camera
//                                self.showingImagePicker.toggle()
                                
                                activeSheet = .second
                            }
                            
                       
                    }
                    
                    HStack {

                        HStack {
                            TextField("Search for foods...", text: $text)
                                  .padding(10)
                                  .background(Color(.systemGray6))
                                  .cornerRadius(8)
                        }

                        Button("Search") {

                            Api().getAutocompleteList(food: text) { foods in
                                self.autocompletedFoods = foods
                            }

                        }
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    }
                    .padding(10)

                    Spacer()

                    if autocompletedFoods.count == 0 {
                        Image("screen 1")
                            .resizable()
                            .aspectRatio(UIImage(named: "screen 1")!.size.width / UIImage(named: "screen 1")!.size.height, contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .cornerRadius(40)
                            .clipped()
                        Text("No foods found...")
                            .font(Font.system(size: 34, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        NavigationView {
                            List(autocompletedFoods, id: \.self) { food in
                                NavigationLink(destination: FoodListRowItem(food: food, mealType: $mealType, showFoodPicker: $showFoodPicker, totalCalories: $totalCalories, date: date)) {
                                    Text(food)
                                }
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        }
                    }
                }
                    
                    Spacer()
                    
                } .navigationBarHidden(true)

        }
        }
        .sheet(item: $activeSheet, onDismiss: loadImage) { item in
                    switch item {
                    case .first:
                        ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType ?? .camera)
                    case .second:
                        SpeechView(mealType: $mealType, showFoodPicker: $showFoodPicker, totalCalories: $totalCalories, date: date)
                }
//        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
//            ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType ?? .camera)
//        }
        }
 
        
    }
    
    
    func loadImage() {
        guard let inputImage = selectedImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func performImageClassify() {
           guard let image = selectedImage, let resizedImage = image.resizeTo(size: CGSize(width: 299, height: 299)),
                 let buffer = resizedImage.toBuffer() else {return}
           
           let output = try? model.prediction(image: buffer)
           
           if let o = output {
               let result = o.classLabel
            originalResult = o.classLabel
            
             let confidenceRate = o.foodConfidence[result]!*100
            if confidenceRate < 50 {
                self.result = "Could not determine what food this is."
                return
            }
            
            self.confirmUseThisFood = true
            self.result = "Scanned food: \(result) \n Accuracy: \(String(confidenceRate).prefix(4))%"
            
           }
       
       }
    
}

