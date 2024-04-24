//
//  TextView.swift
//  Leclerc
//
//  Created by Omar Sánchez on 24/04/24.
//

import SwiftUI

struct TextView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Comparte algo aquí...", text: $text)
                .multilineTextAlignment(.center)
                .font(Font.custom("Caveat", size: 30))

            Spacer()
        }
    }
}

#Preview {
    TextView(text: .constant("Hello world"))
}
