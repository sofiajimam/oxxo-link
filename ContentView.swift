//
//  ContentView.swift
//  Leclerc
//
//  Created by Pablo Salas on 23/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIndex: Int = 0
    var body: some View {
        TabView(selection: $selectedIndex){
            ProfileView().tabItem {
                Label("", systemImage: "doc.richtext").foregroundStyle(.orange)
                }
            ProfileView().tabItem {
                Label("", systemImage: "map").foregroundStyle(.orange)
                }
            
            ProfileView().tabItem {
                Label("", systemImage: "person.fill").foregroundStyle(.orange)
                }
        }
        .tint(Color(red: 0.95, green: 0.60, blue: 0))
                .onAppear(perform: {
                   
                    UITabBar.appearance().unselectedItemTintColor = .systemGray
                   
                    UITabBarItem.appearance().badgeColor = UIColor(Color(red: 0.95, green: 0.60, blue: 0))
                    
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(red: 0.95, green: 0.60, blue: 0))]
                })
    }
}

#Preview {
    ContentView()
}
