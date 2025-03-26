//
//  ExploreView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI
import MapKit

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
        Category(name: "实用信息", icon: "info.circle.fill"),
        Category(name: "行程规划", icon: "map.fill")
    ]
    
    let destinations = [
        "东京", "巴黎", "纽约", "伦敦", "北京", 
        "曼谷", "新加坡", "悉尼", "罗马", "迪拜",
        "首尔", "香港", "巴厘岛", "马尔代夫", "普吉岛"
    ]
    
    let inspirations = [
        "探索东京迷人的文化景点",
        "巴黎必去的10个小众景点",
        "纽约最值得品尝的美食",
        "伦敦博物馆一日游攻略",
        "曼谷水上市场完全指南"
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
                            NavigationLink(
                                destination: destinationView(for: category),
                                label: {
                                    VStack {
                                        Circle()
                                            .fill(category.name == "行程规划" ? Color.orange.opacity(0.2) : Color.gray.opacity(0.2))
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                Image(systemName: category.icon)
                                                    .font(.title2)
                                                    .foregroundColor(category.name == "行程规划" ? .orange : .gray)
                                            )
                                        Text(category.name)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                }
                            )
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
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [colorForDestination(destination), colorForDestination(destination).opacity(0.7)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 120, height: 160)
                                    
                                    Image(systemName: iconForDestination(destination))
                                        .font(.system(size: 30))
                                        .foregroundColor(.white.opacity(0.8))
                                        .offset(y: -20)
                                    
                                    Text(destination)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(6)
                                        .background(Color.black.opacity(0.6))
                                        .cornerRadius(4)
                                        .frame(maxWidth: 120, maxHeight: 160, alignment: .bottom)
                                        .padding(.bottom, 10)
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
                        ForEach(0..<inspirations.count, id: \.self) { index in
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hue: Double(index) * 0.15, saturation: 0.7, brightness: 0.9),
                                                Color(hue: Double(index) * 0.15, saturation: 0.5, brightness: 0.7)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 100, height: 100)
                                    
                                    Image(systemName: inspirationIcons[index % inspirationIcons.count])
                                        .font(.system(size: 36))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(inspirations[index])
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
                                        
                                        Text("\(256 + index * 47)")
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
    
    @ViewBuilder
    private func destinationView(for category: Category) -> some View {
        if category.name == "行程规划" {
            ExploreRouteMapView()
        } else {
            Text(category.name)
                .navigationTitle(category.name)
        }
    }
    
    // 根据目的地返回不同的颜色
    private func colorForDestination(_ destination: String) -> Color {
        switch destination {
        case "东京":
            return Color.red
        case "巴黎":
            return Color.blue
        case "纽约":
            return Color.purple
        case "伦敦":
            return Color(red: 0.0, green: 0.3, blue: 0.6)
        case "北京":
            return Color.red.opacity(0.8)
        case "曼谷":
            return Color.green
        case "新加坡":
            return Color(red: 0.8, green: 0.2, blue: 0.3)
        case "悉尼":
            return Color(red: 0.0, green: 0.5, blue: 0.8)
        case "罗马":
            return Color(red: 0.8, green: 0.6, blue: 0.0)
        case "迪拜":
            return Color(red: 0.9, green: 0.7, blue: 0.0)
        case "首尔":
            return Color(red: 0.5, green: 0.0, blue: 0.9)
        case "香港":
            return Color(red: 0.9, green: 0.0, blue: 0.3)
        case "巴厘岛":
            return Color(red: 0.0, green: 0.7, blue: 0.5)
        case "马尔代夫":
            return Color(red: 0.0, green: 0.8, blue: 0.9)
        case "普吉岛":
            return Color(red: 0.0, green: 0.6, blue: 0.4)
        default:
            return Color.orange
        }
    }
    
    // 根据目的地返回不同的图标
    private func iconForDestination(_ destination: String) -> String {
        switch destination {
        case "东京":
            return "building.2.fill"
        case "巴黎":
            return "building.columns.fill"
        case "纽约":
            return "building.fill"
        case "伦敦":
            return "clock.fill"
        case "北京":
            return "house.fill"
        case "曼谷":
            return "leaf.fill"
        case "新加坡":
            return "helm"
        case "悉尼":
            return "sun.max.fill"
        case "罗马":
            return "crown.fill"
        case "迪拜":
            return "building.columns.circle.fill"
        case "首尔":
            return "camera.macro"
        case "香港":
            return "sparkles"
        case "巴厘岛", "马尔代夫", "普吉岛":
            return "water.waves"
        default:
            return "map.fill"
        }
    }
    
    // 旅游灵感图标集合
    private let inspirationIcons = [
        "camera.fill",
        "fork.knife",
        "building.2.fill",
        "bicycle",
        "bag.fill",
        "figure.hiking",
        "mountain.2.fill",
        "beach.umbrella.fill"
    ]
}

#Preview {
    ExploreView()
} 
