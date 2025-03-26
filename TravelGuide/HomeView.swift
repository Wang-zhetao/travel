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
                            ForEach(["日本", "泰国", "法国", "意大利", "美国", "澳大利亚"], id: \.self) { destination in
                                VStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 70, height: 70)
                                    Text(destination)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("精选攻略")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ForEach(guides) { guide in
                        GuideCard(guide: guide)
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
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(1.5, contentMode: .fit)
                .overlay(
                    Text(guide.destination)
                        .font(.caption)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(4),
                    alignment: .topLeading
                )
            
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
}

#Preview {
    HomeView()
} 
