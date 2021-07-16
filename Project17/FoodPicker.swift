//
//  FoodPicker.swift
//  Project17
//
//  Created by Evan Tu on 7/11/21.
//

import SwiftUI

struct FoodPicker: View {
    
    
    let restaurants = [
            Restaurant(name: "Joe's Original"),
            Restaurant(name: "The Real Joe's Original"),
            Restaurant(name: "Original Joe's")
        ]

    
    
    @Environment(\.colorScheme) var colorScheme

    @State private var sourceType: UIImagePickerController.SourceType?
    @State private var result = ""
    @State private var originalResult = ""
    @State private var image: Image?
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var confirmUseThisFood = false
    
    @State private var text = ""
    
    let model = Food101()
    
    var body: some View {
        VStack {
            if let image = image {
            
                VStack {
               
                    image
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            self.performImageClassify()
                        }
                    Text(self.result)
                }
                
            } else {
               
                VStack {
                
                    HStack {
                        VStack(alignment: .leading) {
                            Button(action: {
                                self.sourceType = .camera
                                self.showingImagePicker.toggle()
                            }) {
                                Image(systemName: "camera")
                                Text("Scan")
                            }
                        }
                        .padding(10)
                        
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .cornerRadius(25)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .onTapGesture {
                            self.sourceType = .camera
                            self.showingImagePicker.toggle()
                        }

                    HStack {
                        TextField("Search for foods...", text: $text)
                              .padding(10)
                              .background(Color(.systemGray6))
                              .cornerRadius(8)
                    }
                    }
                    .padding(10)
                    
                    Spacer()
                    
                    NavigationView {
                            List(restaurants) { restaurant in
                                NavigationLink(destination: Text("Hello.")) {
                                    RestaurantRow(restaurant: restaurant)
                                }
                           }
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                    
                }
                    
            
            }
          
            
            
            if self.confirmUseThisFood == true {
                Button("Use this image...") {
                    
                    print(self.originalResult)
                    
                    self.result = ""
                    self.selectedImage = nil
                    self.showingImagePicker = false
                    self.image = nil
                    self.confirmUseThisFood = false
                    self.originalResult = ""
                }
                .padding()
                .frame(width: 300, height: 100)
                .background(Color.blue)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            }
            
            Spacer()
                   .frame(height: 20)
            
            Button("Choose another image") {
                self.result = ""
                self.selectedImage = nil
                self.showingImagePicker = false
                self.image = nil
                self.confirmUseThisFood = false
                self.originalResult = ""
            }
            .padding()
            .frame(width: 300, height: 52)
            .background(Color.purple)
            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType ?? .camera)
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
            self.result = "The food is \(result), estimated probability of \(String(confidenceRate).prefix(4))%."
           }
       
       }
    
}

struct FoodPicker_Previews: PreviewProvider {
    static var previews: some View {
        FoodPicker()
    }
}





// A struct to store exactly one restaurant's data.
struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
}

// A view that shows the data for one Restaurant.
struct RestaurantRow: View {
    var restaurant: Restaurant

    var body: some View {
        Text("Come and eat at \(restaurant.name)")
    }
}
