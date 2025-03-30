//
//  ExploreView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI
import MapKit
import Foundation

// 添加 View 扩展以支持特定角落的圆角
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// 自定义形状以支持特定角落的圆角
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

struct ExploreView: View {
    @State private var searchText = ""
    
    // 分类项数据
    let categories = [
        CategoryItem(name: "美食", icon: "fork.knife", color: .gray),
        CategoryItem(name: "住宿", icon: "bed.double.fill", color: .gray),
        CategoryItem(name: "景点", icon: "mountain.2.fill", color: .gray),
        CategoryItem(name: "购物", icon: "bag.fill", color: .gray),
        CategoryItem(name: "交通", icon: "car.fill", color: .gray),
        CategoryItem(name: "实用信息", icon: "info.circle.fill", color: .gray),
        CategoryItem(name: "行程规划", icon: "map.fill", color: .orange)
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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // 搜索栏
                    searchBarView
                    
                    // 分类集合
                    categorySectionView
                    
                    Divider()
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                    
                    // 热门目的地
                    destinationSectionView
                    
                    Divider()
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                    
                    // 旅游灵感
                    inspirationSectionView
                }
            }
            .navigationTitle("发现")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // 搜索栏视图
    private var searchBarView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 44)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                TextField("搜索目的地或旅游灵感", text: $searchText)
                    .font(.system(size: 16))
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    // 分类部分视图
    private var categorySectionView: some View {
        VStack(spacing: 0) {
            // 分类标题
            categoryHeaderView
            
            // 分类网格
            categoryGridView
        }
    }
    
    // 分类标题视图
    private var categoryHeaderView: some View {
        HStack {
            Text("分类")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.black, Color(red: 0.3, green: 0.3, blue: 0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Spacer()
            
            Button(action: {
                print("点击查看全部分类")
            }) {
                Text("查看全部")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal)
        .padding(.top, 25)
    }
    
    // 分类网格视图
    private var categoryGridView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 18) {
            ForEach(categories) { category in
                categoryItemView(category: category)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 5)
    }
    
    // 单个分类项视图
    private func categoryItemView(category: CategoryItem) -> some View {
        NavigationLink(destination: {
            if category.name == "行程规划" {
                ExploreRouteMapView()
            } else if category.name == "交通" {
                TransportationView()
            } else {
                Text(category.name)
                    .navigationTitle(category.name)
            }
        }) {
            VStack(spacing: 6) {
                ZStack {
                    // 外圈
                    Circle()
                        .fill(Color(UIColor.systemGray6))
                        .frame(width: 65, height: 65)
                        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
                    
                    if category.name == "行程规划" {
                        // 高亮圆形背景
                        categoryHighlightView
                    } else {
                        // 普通分类圆形内部装饰
                        Circle()
                            .stroke(Color(UIColor.systemGray5), lineWidth: 3)
                            .frame(width: 57, height: 57)
                    }
                    
                    // 图标
                    Image(systemName: category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(category.name == "行程规划" ? .white : .gray)
                }
                
                Text(category.name)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
            }
            .padding(.vertical, 8)
            .scaleEffect(category.name == "行程规划" ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // 高亮分类背景视图
    private var categoryHighlightView: some View {
        ZStack {
            // 高亮圆形背景
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.orange, Color.orange.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 65, height: 65)
            
            // 顶部弧形装饰
            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                .frame(width: 55, height: 55)
                .rotationEffect(.degrees(-45))
        }
    }
    
    // 目的地部分视图
    private var destinationSectionView: some View {
        VStack(spacing: 0) {
            // 目的地标题
            destinationHeaderView
            
            // 目的地滚动视图
            destinationScrollView
        }
    }
    
    // 目的地标题视图
    private var destinationHeaderView: some View {
        HStack {
            Text("热门目的地")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.black, Color(red: 0.3, green: 0.3, blue: 0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Spacer()
            
            Button(action: {
                print("点击查看更多目的地")
            }) {
                Text("更多")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal)
        .padding(.top, 5)
    }
    
    // 目的地滚动视图
    private var destinationScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(destinations, id: \.self) { destination in
                    destinationItemView(destination: destination)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 15)
        }
    }
    
    // 单个目的地项视图
    private func destinationItemView(destination: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                // 背景圆形
                Circle()
                    .fill(colorForDestination(destination).opacity(0.15))
                    .frame(width: 70, height: 70)
                
                // 内部圆形
                Circle()
                    .stroke(colorForDestination(destination), lineWidth: 2)
                    .frame(width: 60, height: 60)
                
                // 目的地首字母
                Text(String(destination.prefix(1)))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(colorForDestination(destination))
            }
            
            Text(destination)
                .font(.system(size: 13))
                .foregroundColor(.black)
        }
    }
    
    // 灵感部分视图
    private var inspirationSectionView: some View {
        VStack(spacing: 0) {
            // 灵感标题
            inspirationHeaderView
            
            // 灵感列表
            inspirationListView
        }
    }
    
    // 灵感标题视图
    private var inspirationHeaderView: some View {
        HStack {
            Text("旅游灵感")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.black, Color(red: 0.3, green: 0.3, blue: 0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Spacer()
            
            Button(action: {
                print("点击查看更多灵感")
            }) {
                Text("更多")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal)
        .padding(.top, 5)
    }
    
    // 灵感列表视图
    private var inspirationListView: some View {
        VStack(spacing: 22) {
            ForEach(0..<inspirations.count, id: \.self) { index in
                inspirationItemView(index: index)
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 30)
    }
    
    // 单个灵感项视图
    private func inspirationItemView(index: Int) -> some View {
        let inspiration = inspirations[index]
        let destination = destinations[index % destinations.count]
        
        return NavigationLink(destination: InspirationDetailView(inspiration: inspiration, destination: destination)) {
            VStack(alignment: .leading, spacing: 0) {
                // 内容卡片
                inspirationCardView(inspiration: inspiration, destination: destination)
                
                // 互动区域
                inspirationInteractionView
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle()) // 使导航链接不影响卡片样式
        .padding(.horizontal)
    }
    
    // 灵感卡片视图
    private func inspirationCardView(inspiration: String, destination: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // 左侧图片
            inspirationImageView(destination: destination)
            
            // 右侧内容
            inspirationContentView(inspiration: inspiration, destination: destination)
        }
        .frame(height: 110)
    }
    
    // 灵感图片视图
    private func inspirationImageView(destination: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            // 基础形状
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [colorForDestination(destination).opacity(0.7), colorForDestination(destination).opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 110, height: 110)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // 目的地名称标签
            Text(destination)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(4)
                .padding(8)
        }
    }
    
    // 灵感内容视图
    private func inspirationContentView(inspiration: String, destination: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // 作者信息
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.orange)
                
                Text("旅行达人")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // 灵感标题
            Text(inspiration)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // 时间和阅读量
            HStack {
                Image(systemName: "clock")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Text("2天前")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "eye")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Text("1.2k阅读")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
        .padding(.trailing, 10)
    }
    
    // 灵感互动视图
    private var inspirationInteractionView: some View {
        HStack(spacing: 20) {
            // 点赞
            HStack(spacing: 4) {
                Image(systemName: "heart")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("128")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // 评论
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("32")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // 收藏
            HStack(spacing: 4) {
                Image(systemName: "bookmark")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("收藏")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 分享
            HStack(spacing: 4) {
                Image(systemName: "square.and.arrow.up")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("分享")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color(UIColor.systemGray6).opacity(0.5))
        .cornerRadius(14, corners: [.bottomLeft, .bottomRight])
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

// 分类项模型
struct CategoryItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

// 添加 InspirationDetailView
struct InspirationDetailView: View {
    let inspiration: String
    let destination: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 顶部图片区域
                ZStack(alignment: .bottomLeading) {
                    // 背景图片
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.95, green: 0.95, blue: 0.95),
                                    Color(red: 0.9, green: 0.9, blue: 0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 280)
                    
                    // 渐变遮罩
                    LinearGradient(
                        colors: [
                            .clear,
                            .black.opacity(0.3),
                            .black.opacity(0.7)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 280)
                    
                    // 标题和目的地信息
                    VStack(alignment: .leading, spacing: 12) {
                        // 目的地标签
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.orange)
                            Text(destination)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(20)
                        
                        // 标题
                        Text(inspiration)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // 作者信息
                HStack(spacing: 12) {
                    // 头像
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.orange)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // 作者名称
                        HStack {
                            Text("旅行博主")
                                .font(.system(size: 16, weight: .medium))
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 12))
                        }
                        
                        // 发布时间
                        Text("发布于 2024/03/26")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // 关注按钮
                    Button(action: {
                        print("关注作者")
                    }) {
                        Text("关注")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // 推荐景点
                VStack(alignment: .leading, spacing: 16) {
                    Text("推荐景点")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    ForEach(1...3, id: \.self) { index in
                        HStack(spacing: 12) {
                            // 景点图片
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("推荐景点 \(index)")
                                    .font(.system(size: 16, weight: .medium))
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("4.\(index)")
                                        .foregroundColor(.orange)
                                    Text("(\(100 + index * 50)条评价)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                
                                Text("景点简介：这里是关于景点的简要描述...")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                        .padding(12)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // 美食推荐
                VStack(alignment: .leading, spacing: 16) {
                    Text("美食推荐")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    ForEach(1...3, id: \.self) { index in
                        HStack(spacing: 12) {
                            // 餐厅图片
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "fork.knife")
                                        .font(.system(size: 30))
                                        .foregroundColor(.orange)
                                )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("推荐餐厅 \(index)")
                                    .font(.system(size: 16, weight: .medium))
                                
                                HStack {
                                    ForEach(0..<5) { starIndex in
                                        Image(systemName: starIndex < (5 - index/2) ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 12))
                                    }
                                    Text("(\(80 + index * 50)条评价)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                
                                Text("人均: ¥\((150 + index * 100))/人")
                                    .font(.system(size: 12))
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(12)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                
                // 交通信息
                VStack(alignment: .leading, spacing: 16) {
                    Text("交通信息")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    VStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { index in
                            HStack(spacing: 16) {
                                // 交通方式图标
                                Image(systemName: ["car.fill", "airplane", "train.side.front.car"][index - 1])
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.orange)
                                    .cornerRadius(20)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(["出租车", "飞机", "地铁"][index - 1])
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text(["便捷但价格较高", "最快速的选择", "经济实惠"][index - 1])
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                // 预估价格
                                Text("¥\(index * 100)+")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.orange)
                            }
                            .padding(12)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // 底部互动区域
                HStack(spacing: 20) {
                    Button(action: {
                        print("收藏")
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "bookmark")
                            Text("收藏")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(20)
                    }
                    
                    Button(action: {
                        print("分享")
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                            Text("分享")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("开始规划")
                    }) {
                        Text("开始规划")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.orange)
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("更多选项")
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    ExploreView()
} 
