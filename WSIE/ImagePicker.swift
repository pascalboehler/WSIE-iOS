//
//  ImagePicker.swift
//  WSIE
//
//  Created by Pascal Boehler on 02.03.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import SwiftUI

struct ImagePickerViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerViewController>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerViewController>) {
        
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerViewController
        
        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> ImagePickerViewController.Coordinator {
        Coordinator(self)
    }
    
}

struct ImagePicker: View {
    
    @Binding var image: UIImage
    
    var body: some View {
        ImagePickerViewController(image: $image)
    }
    
}

