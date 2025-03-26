//
//  ExploreView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

struct ExploreView: View {
    let categories = [
        Category(name: "美食", icon: "fork.knife"),
        Category(name: "住宿", icon: "bed.double.fill"),
        Category(name: "景点", icon: "mountain.2.fill"),
        Category(name: "购物", icon: "bag.fill"),
        Category(name: "交通", icon: "car.fill"),
        Category(name: "实用信息", icon: "info.circle.fill")
    ]
    
    let destinations = [
        "东京", "巴黎", "纽约", "伦敦", "北京", 
        "曼谷", "新加坡", "悉尼", "罗马", "迪拜",
        "首尔", "香港", "巴厘岛", "马尔代夫", "普吉岛"
    ]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 分类导航
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(categories) { category in
                            VStack {
                                Circle()
                                    .fill(Color.orange.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: category.icon)
                                            .font(.title2)
                                            .foregroundColor(.orange)
                                    )
                                Text(category.name)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 热门目的地
                    Text("热门目的地")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(destinations, id: \.self) { destination in
                                VStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 120, height: 160)
                                        .cornerRadius(8)
                                        .overlay(
                                            Text(destination)
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .padding(6)
                                                .background(Color.black.opacity(0.6))
                                                .cornerRadius(4),
                                            alignment: .bottom
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 旅游灵感
                    Text("旅游灵感")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        ForEach(1...5, id: \.self) { _ in
                            HStack(alignment: .top, spacing: 12) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("旅行灵感标题")
                                        .font(.headline)
                                        .lineLimit(2)
                                    
                                    Text("这里是旅行灵感的简短描述，包含一些有用的信息和建议...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(3)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Image(systemName: "person.circle.fill")
                                            .foregroundColor(.gray)
                                        
                                        Text("旅行博主")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "heart")
                                            .foregroundColor(.gray)
                                        
                                        Text("256")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .frame(height: 100)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("发现")
            .searchable(text: $searchText, prompt: "搜索目的地或旅游灵感")
        }
    }
}

#Preview {
    ExploreView()
} 
