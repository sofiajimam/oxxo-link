//
//  StickerView.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import SwiftUI

struct StickerView: View {
    @Binding var identifier: Sticker
    
    var stickerDict: [Sticker: String] = [
        .coke: "sticker_1",
        .person: "sticker_2",
        .coffee: "sticker_3"
    ]
    
    func changeSticker() {
        switch identifier {
        case .coke:
            identifier = .person
        case .person:
            identifier = .coffee
        case .coffee:
            identifier = .coke
        }
    }
    
    var body: some View {
        Image(stickerDict[identifier] ?? "sticker_1")
            .scaleEffect(0.4)
            .onTapGesture {
                changeSticker()
            }
    }
}

#Preview {
    StickerView(identifier: .constant(.coke))
}
