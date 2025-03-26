//
//  HomeView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI

struct TravelGuide: Identifiable {
    let id = UUID()
    let title: String
    let destination: String
    let imageURL: String
    let author: String
    let likes: Int
}

struct HomeView: View {
    @State private var guides = [
        TravelGuide(title: "东京7日游完全攻略", destination: "日本东京", imageURL: "tokyo", author: "旅行达人", likes: 1243),
        TravelGuide(title: "巴黎浪漫之旅", destination: "法国巴黎", imageURL: "paris", author: "环球旅行家", likes: 895),
        TravelGuide(title: "纽约城市探索", destination: "美国纽约", imageURL: "newyork", author: "城市观察者", likes: 764),
        TravelGuide(title: "泰国清迈美食之旅", destination: "泰国清迈", imageURL: "chiangmai", author: "美食猎人", likes: 1056)
    ]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("热门目的地")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            DestinationCircle(name: "日本", icon: "building.2.fill", color: .red)
                                .onTapGesture {
                                    // 处理点击日本目的地
                                    print("点击了日本目的地")
                                }
                            DestinationCircle(name: "泰国", icon: "leaf.fill", color: .green)
                                .onTapGesture {
                                    // 处理点击泰国目的地
                                    print("点击了泰国目的地")
                                }
                            DestinationCircle(name: "法国", icon: "building.columns.fill", color: .blue)
                                .onTapGesture {
                                    // 处理点击法国目的地
                                    print("点击了法国目的地")
                                }
                            DestinationCircle(name: "意大利", icon: "cup.and.saucer.fill", color: .orange)
                                .onTapGesture {
                                    // 处理点击意大利目的地
                                    print("点击了意大利目的地")
                                }
                            DestinationCircle(name: "美国", icon: "star.fill", color: .purple)
                                .onTapGesture {
                                    // 处理点击美国目的地
                                    print("点击了美国目的地")
                                }
                            DestinationCircle(name: "澳大利亚", icon: "fish.fill", color: .teal)
                                .onTapGesture {
                                    // 处理点击澳大利亚目的地
                                    print("点击了澳大利亚目的地")
                                }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("精选攻略")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ForEach(guides) { guide in
                        NavigationLink(destination: GuideDetailView(guide: guide)) {
                            GuideCard(guide: guide)
                        }
                        .buttonStyle(PlainButtonStyle()) // 保持卡片原有样式
                    }
                }
                .padding(.top)
            }
            .navigationTitle("旅游攻略")
            .searchable(text: $searchText, prompt: "搜索目的地或攻略")
        }
    }
}

struct GuideCard: View {
    let guide: TravelGuide
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                // 渐变色背景代替图片
                LinearGradient(
                    gradient: Gradient(colors: [
                        colorForDestination(guide.destination),
                        colorForDestination(guide.destination).opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .aspectRatio(1.5, contentMode: .fit)
                
                // 添加图标
                Image(systemName: iconForDestination(guide.destination))
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                
                // 目的地标签
                Text(guide.destination)
                    .font(.caption)
                    .padding(6)
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(guide.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text(guide.author)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .imageScale(.small)
                    
                    Text("\(guide.likes)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // 根据目的地返回不同的颜色
    private func colorForDestination(_ destination: String) -> Color {
        switch destination {
        case _ where destination.contains("东京"):
            return Color.red
        case _ where destination.contains("巴黎"):
            return Color.blue
        case _ where destination.contains("纽约"):
            return Color.purple
        case _ where destination.contains("泰国"):
            return Color.green
        default:
            return Color.orange
        }
    }
    
    // 根据目的地返回不同的图标
    private func iconForDestination(_ destination: String) -> String {
        switch destination {
        case _ where destination.contains("东京"):
            return "building.2.fill"
        case _ where destination.contains("巴黎"):
            return "building.columns.fill"
        case _ where destination.contains("纽约"):
            return "building.fill"
        case _ where destination.contains("泰国"):
            return "leaf.fill"
        default:
            return "map.fill"
        }
    }
}

struct DestinationCircle: View {
    let name: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [color, color.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 70, height: 70)
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            Text(name)
                .font(.caption)
        }
    }
}

#Preview {
    HomeView()
} 
