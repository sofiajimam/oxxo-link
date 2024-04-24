//
//  OnboardingView.swift
//  Leclerc
//
//  Created by Pablo Salas on 24/04/24.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var body: some View {
        VStack{
            HStack{
                Image("LogoTop").resizable().frame(width: 30, height: 30).scaledToFit().clipShape(Rectangle())
                Spacer().frame(width: 300)
            }
            Spacer()
            
            Image("Onboarding").resizable().frame(width: 300, height: 250).scaledToFit().clipShape(Rectangle())
            VStack{
                Text("¡Bienvenido!").font(Font.custom("Poppins", size: 24).weight(.semibold)).foregroundStyle(Color(red: 0.95, green: 0.60, blue: 0))
                Text("\nYo soy Oxxo Hi, el tablero virtual en donde puedes conectar con personas de tu comunidad.\n\n¿Estas preparado para comenzar?").font(Font.custom("Poppins", size: 16))
                    .foregroundColor(Color.gray).multilineTextAlignment(.center).frame(width: 250)
            }
            Button(action: {
                    isOnboarding = false
            }) {
                HStack(spacing: 8) {
                    Text("¡Vamos!").foregroundStyle(Color(red: 0.95, green: 0.60, blue: 0))
                    
                    Image(systemName: "arrow.right.circle")
                        .imageScale(.large).foregroundStyle(Color(red: 0.95, green: 0.60, blue: 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule().strokeBorder(Color.white, lineWidth: 1.25)
                )
            }
            Spacer()
            VStack{
                Rectangle().foregroundStyle(Color(red: 0.95, green: 0.60, blue: 0)).frame(height: 4)
                Rectangle().foregroundStyle(Color(red: 0.90, green: 0, blue: 0.13)).frame(height: 4)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
