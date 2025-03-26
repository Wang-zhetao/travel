//
//  ContentView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首页")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "safari.fill")
                    Text("发现")
                }
                .tag(1)
            
            ImportView()
                .tabItem {
                    Image(systemName: "square.and.arrow.down.fill")
                    Text("导入")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
                .tag(3)
        }
        .accentColor(.orange)
    }
}

#Preview {
    ContentView()
}
