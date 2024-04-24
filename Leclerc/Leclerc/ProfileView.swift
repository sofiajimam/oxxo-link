//
//  ProfileView.swift
//  Leclerc
//
//  Created by Pablo Salas on 23/04/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(){
            VStack(){
                Rectangle().frame(width: 100, height: 40)
                Image("Omar").resizable().frame(width: 100, height: 100).scaledToFit().clipShape(Rectangle())
                Text("Pablo Salas").font(.system(size: 18))
                Text("@PabloSalas19").foregroundStyle(Color.gray).font(.system(size: 12))
                HStack{
                    Image(systemName: "storefront.fill").foregroundStyle(.gray)
                    Text("6").bold()
                }.frame(width: 80, height: 30).overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 0.50))
                HStack(){
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Medallas").foregroundStyle(Color(red: 0.95, green: 0.60, blue: 0))
                        Spacer().frame(height: 30)
                        Rectangle().frame(height: 2).foregroundStyle(Color(red: 0.95, green: 0.60, blue: 0))
                    }.frame(width: 100, height: 100)
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Misiones").foregroundStyle(Color.gray)
                        Spacer().frame(height: 30)
                        Rectangle().frame(height: 2).foregroundStyle(Color.white)
                    }.frame(width: 100, height: 100)
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Eventos").foregroundStyle(Color.gray)
                        Spacer().frame(height: 30)
                        Rectangle().frame(height: 2).foregroundStyle(Color.white)
                    }.frame(width: 100, height: 100)
                    Spacer()
                }
                
            }
            VStack{
                Rectangle().foregroundStyle(.clear)
            }.background(Color(red: 0.97, green: 0.97, blue: 0.97)).frame(width: .infinity, height: .infinity)
            Spacer()
        }
    }
}

#Preview {
    ProfileView()
}
