//
//  ElementButton.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import SwiftUI

struct ElementButton: View {
    let symbol: String
    @State var photoCount = 0
    let action: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: symbol)
                .foregroundColor(.white)
                .symbolEffect(.bounce.down, value: photoCount)
        }
        .frame(width: 40, height: 40)
        .background(.orange)
        .cornerRadius(10)
        .onTapGesture {
            photoCount += 1
            action()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ElementButton(symbol: "photo") {}
}
