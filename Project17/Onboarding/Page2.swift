//
//  Page2.swift
//  Project17
//
//  Created by Evan Tu on 7/13/21.
//

import SwiftUI
import Combine

struct Page2: View {
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
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
                
            Text("What is your biological sex?")
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
               
        }.padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
    }
}


final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
