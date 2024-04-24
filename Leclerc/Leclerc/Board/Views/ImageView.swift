//
//  ImageView.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import SwiftUI
import PhotosUI

extension Image {
    // Function to convert SwiftUI Image to Base64
    func toBase64() -> String {
        // Convert SwiftUI Image to UIImage
        guard let uiImage = self.asUIImage() else {
            return ""
        }
        
        // Convert UIImage to Data
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0) else {
            return ""
        }
        
        // Convert Data to Base64
        let base64String = imageData.base64EncodedString()
        
        return base64String
    }
    
    // Helper function to convert SwiftUI Image to UIImage
    func asUIImage() -> UIImage? {
        var image: UIImage? = nil
        DispatchQueue.main.sync {
            // Render SwiftUI Image to UIImage
            let controller = UIHostingController(rootView: self)
            controller.view.bounds = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            image = controller.view.asImage()
        }
        return image
    }
}

extension UIView {
    // Function to render UIView to UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct ImageView: View {
    @State private var picker: PhotosPickerItem?
    @State private var isPickerShown: Bool = false
    @Binding var url: String

    func pickImage() async {
        if let loaded = try? await picker?.loadTransferable(type: Image.self) {
            url = loaded.toBase64()
            print(url)
        } else {
            print("Failed")
        }
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: url)!)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .onTapGesture {
                    isPickerShown = true
                }
        }
        .photosPicker(isPresented: $isPickerShown, selection: $picker, matching: .images)
        .onChange(of: picker) {
            Task {
                await pickImage()
            }
        }
    }
}

#Preview {
    ImageView(url: .constant("https://assets.isu.pub/document-structure/230215171205-38e58f86525fc877bb1118801b26f5a6/v1/f1422cd90c5377d2b5dba031489b9c07.jpeg"))
}
