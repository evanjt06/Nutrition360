//
//  FoodPicker.swift
//  Project17
//
//  Created by Evan Tu on 7/11/21.
//

import SwiftUI

struct FoodPicker: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var sourceType: UIImagePickerController.SourceType?
    @State private var result = ""
    @State private var originalResult = ""
    @State private var image: Image?
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var confirmUseThisFood = false
    
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
               
                GeometryReader { geometry in
                    VStack(alignment: .leading) {
                        Button("Use camera") {
                            self.sourceType = .camera
                            self.showingImagePicker.toggle()
                       }
                        .font(.headline)
                    }
                    .frame(maxWidth: geometry.size.width)
                    .padding(50)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .onTapGesture {
                        self.sourceType = .camera
                        self.showingImagePicker.toggle()
                    }
                }
            }
            
            Spacer()
            
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
            .frame(width: 300, height: 100)
            .background(Color.blue)
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
