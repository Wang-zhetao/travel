//
//  TravelGuideApp.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI

@main
struct TravelGuideApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 设置UI样式
                    UITabBar.appearance().backgroundColor = UIColor.systemBackground
                    UINavigationBar.appearance().tintColor = UIColor.orange
                }
        }
    }
}
