//
//  BoardView.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var model: BoardViewModel
    
    var body: some View {
        let renderables = model.render()
        
        return VStack {
            ZStack {
                ForEach(renderables.indices, id: \.self) { index in
                    renderables[index]
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                ElementButton(symbol: "photo") {
                        model.addElement(type: "Image", content: ImageInput(url: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/XC2V1522_FACHADA_OXXO_CERCA_andatti.jpg/320px-XC2V1522_FACHADA_OXXO_CERCA_andatti.jpg"))
                    }
                ElementButton(symbol: "textformat.alt") {
                        model.addElement(type: "Text", content: TextInput(text: "Comparte algo aquí..."))
                    }
                ElementButton(symbol: "photo.stack") {
                        model.addElement(type: "Sticker", content: SticketInput(identifier: .coke))
                    }
            }
        }
    }
}

#Preview {
    BoardView(model: sampleViewModel)
}
