//
//  Page2.swift
//  Project17
//
//  Created by Evan Tu on 7/13/21.
//

import SwiftUI

struct Page2: View {
    
    let genders = ["Male", "Female"]
    @Binding var name: String
    @Binding var gender: String
    
    var body: some View {
        let size = UIImage(named: "screen 4")!.size
        let aspect = size.width / size.height
        
        return VStack(alignment: .center, spacing: 50) {
            Text("Please answer these questions.")
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Image("screen 4")
                .resizable()
                .aspectRatio(aspect, contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(40)
                .clipped()

            VStack {
            Text("What is your name?")
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            TextField("", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
                Spacer().frame(height:30)
                
            Text("What is your gender?")
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            Picker("", selection: $gender) {
                            ForEach(genders, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                
            }.padding()
               
        }
    }
}
