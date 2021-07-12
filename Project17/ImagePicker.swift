//
//  ImagePicker.swift
//  RealInstafilter
//
//  Created by Evan Tu on 6/28/21.
//
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  
    @Binding var selectedImage: UIImage?
   @Environment(\.presentationMode) var isPresented
   var sourceType: UIImagePickerController.SourceType?
  
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: ImagePicker
        
        init(picker: ImagePicker) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.selectedImage = selectedImage
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(picker: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    
        let imagePicker = UIImagePickerController()
       imagePicker.sourceType = self.sourceType!
       imagePicker.delegate = context.coordinator // confirming the delegate
       return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}

