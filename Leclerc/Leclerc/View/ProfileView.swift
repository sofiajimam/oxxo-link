//
//  ProfileView.swift
//  Leclerc
//
//  Created by Pablo Salas on 23/04/24.
//


enum TabbedItems: Int, CaseIterable{
    case badges = 0
    case missions = 1
    case events = 2
    
    var title: String{
        switch self {
        case .badges:
            return "Medallas"
        case .missions:
            return "Misiones"
        case .events:
            return "Eventos"
        }
    }
}

import SwiftUI

struct ProfileView: View {
    @State var selectedTab = 0
    
    var body: some View {
        VStack(){
            VStack(){
                Image("LogoTop").clipShape(Rectangle()).padding([.bottom], 20)
                Image("Omar").resizable().frame(width: 100, height: 100).scaledToFit().clipShape(Rectangle())
                Text("Pablo Salas").font(.system(size: 18))
                Text("@PabloSalas19").foregroundStyle(Color.gray).font(.system(size: 12)).padding([.bottom], 20)
                HStack{
                    Image(systemName: "storefront.fill").foregroundStyle(.gray)
                    Text("6").bold()
                }.frame(width: 80, height: 30).overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 0.50))
                HStack(){
                    ZStack{
                        HStack{
                            ForEach((TabbedItems.allCases), id: \.self){ item in
                                Button{
                                    selectedTab = item.rawValue
                                } label: {
                                    CustomTabItem(title: item.title, isActive: (selectedTab == item.rawValue))
                                }
                            }
                        }
                        .padding(2)
                    }
                    .frame(height: 70)
                    .padding(.horizontal, 26).offset(x:0,y:20)
                   
                }
                
            }
            VStack{
                ZStack(alignment: .bottom){
                    TabView(selection: $selectedTab) {
                        BadgesView()
                            .tag(0)
                        
                        MissionView()
                            .tag(1)
                        
                        EventsView()
                            .tag(2)
                    }
                }.background(Color(red: 0.97, green: 0.97, blue: 0.97))
            }.frame(width: .infinity, height: .infinity)
            Spacer()
            
        }
    }
}

extension ProfileView{
    func CustomTabItem(title: String, isActive: Bool) -> some View{
        VStack(){
            Spacer()
            Text(title)
                .font(.custom("Roboto", size: 16))
                .foregroundColor(isActive ? Color(red: 0.90, green: 0, blue: 0.13) : .gray)
            Rectangle().foregroundStyle(isActive ? Color(red: 0.90, green: 0, blue: 0.13) : .clear).frame(height: 6)
            
        }
        .frame(width: isActive ? 100 : 100, height: 50)
        
    }
}



#Preview {
    ProfileView()
}
