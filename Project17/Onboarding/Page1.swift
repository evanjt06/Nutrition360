//
//  Page1.swift
//  Project17
//
//  Created by Evan Tu on 7/13/21.
//

import SwiftUI

struct Page1: View {
    
    var body: some View {
        
        let size = UIImage(named: "screen 1")!.size
        let aspect = size.width / size.height
        
        return VStack(alignment: .center, spacing: 50) {
            Text("Welcome to Nutrition360!")
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Image("screen 1")
                .resizable()
                .aspectRatio(aspect, contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(40)
                .clipped()

            Text("Nutrition360 is a nutrition-oriented app that helps track the foods you eat daily as well as your caloric intake.")
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 300, alignment: .center)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
        }
    }
}

struct Page1_Previews: PreviewProvider {
    static var previews: some View {
        Page1()
    }
}
