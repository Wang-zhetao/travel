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
    
    // 添加小红书风格的旅游灵感数据
    @State private var inspirations = [
        RedBookInspiration(
            title: "京都和服体验｜超治愈的小众赏樱地✨",
            author: "樱花少女",
            likes: 3268,
            comments: 127,
            content: "今年的樱花季提前来临，偶然发现了这个人少景美的赏樱秘境！和服体验店铺就在附近，换好和服徒步5分钟就到了，拍照绝美，还能避开人潮，简直是赏樱胜地！#京都旅行 #樱花季 #日本旅拍",
            tags: ["京都旅行", "樱花季", "日本旅拍", "和服体验"],
            colorScheme: .pink,
            imageURL: "kyoto_kimono"
        ),
        RedBookInspiration(
            title: "曼谷探店｜隐藏在巷子里的复古咖啡馆☕",
            author: "咖啡控",
            likes: 2156,
            comments: 98,
            content: "这家藏在曼谷老城区小巷里的咖啡馆绝对是文艺青年的天堂！复古装潢配上泰式风情，手冲咖啡香气扑鼻，必点招牌椰香咖啡和芒果糯米饭，味道惊艳！重点是很少中国游客，绝对小众！#曼谷美食 #泰国咖啡 #探店",
            tags: ["曼谷美食", "泰国咖啡", "探店", "小众地点"],
            colorScheme: .orange,
            imageURL: "bangkok_coffee"
        ),
        RedBookInspiration(
            title: "巴黎周边一日游｜绝美薰衣草庄园🏰",
            author: "旅行摄影师",
            likes: 4521,
            comments: 203,
            content: "从巴黎出发只需2小时，就能到达这片紫色的梦幻天堂！普罗旺斯的薰衣草田，建议6-7月来，紫色花海一望无际，空气中弥漫着香味，随手一拍都是大片！小贴士：建议包车前往，公共交通略复杂，早上出发傍晚回巴黎刚好~#法国旅行 #薰衣草 #普罗旺斯",
            tags: ["法国旅行", "薰衣草", "巴黎周边", "普罗旺斯"],
            colorScheme: .purple,
            imageURL: "provence_lavender"
        ),
        RedBookInspiration(
            title: "纽约超治愈露台餐厅🍸无敌夜景",
            author: "纽约吃货",
            likes: 3789,
            comments: 156,
            content: "刚发现的纽约绝佳约会地点！这家位于布鲁克林的露台餐厅视野超棒，可以俯瞰整个曼哈顿天际线，入夜后灯光璀璨，和爱的人喝一杯简直不要太浪漫～意大利菜做得地道，推荐松露意面和提拉米苏！预定难度：⭐⭐⭐⭐ 需提前两周预约。#纽约约会 #夜景 #美食推荐",
            tags: ["纽约约会", "夜景", "美食推荐", "布鲁克林"],
            colorScheme: .blue,
            imageURL: "newyork_restaurant"
        )
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
                    
                    Text("旅游灵感")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // 小红书风格的旅游灵感
                    ForEach(inspirations) { inspiration in
                        NavigationLink(destination: RedBookInspirationDetailView(inspiration: inspiration)) {
                            RedBookInspirationCard(inspiration: inspiration)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
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

// 小红书风格灵感数据模型
struct RedBookInspiration: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let likes: Int
    let comments: Int
    let content: String
    let tags: [String]
    let colorScheme: ColorScheme
    let imageURL: String
    
    enum ColorScheme {
        case pink, orange, blue, purple, green
        
        var gradient: [Color] {
            switch self {
            case .pink:
                return [Color.pink, Color.pink.opacity(0.7)]
            case .orange:
                return [Color.orange, Color.orange.opacity(0.7)]
            case .blue:
                return [Color.blue, Color.blue.opacity(0.7)]
            case .purple:
                return [Color.purple, Color.purple.opacity(0.7)]
            case .green:
                return [Color.green, Color.green.opacity(0.7)]
            }
        }
        
        var icon: String {
            switch self {
            case .pink: return "heart.fill"
            case .orange: return "cup.and.saucer.fill"
            case .blue: return "building.fill"
            case .purple: return "camera.fill"
            case .green: return "leaf.fill"
            }
        }
    }
}

// 小红书风格灵感卡片
struct RedBookInspirationCard: View {
    let inspiration: RedBookInspiration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 顶部图片区域（小红书风格）
            ZStack(alignment: .bottomLeading) {
                // 使用真实图片替代渐变背景
                if let uiImage = UIImage(named: inspiration.imageURL) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    // 备用渐变背景
                    LinearGradient(
                        gradient: Gradient(colors: inspiration.colorScheme.gradient),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 200)
                    .cornerRadius(8)
                    
                    // 中央图标
                    Image(systemName: inspiration.colorScheme.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                // 标题覆盖在底部
                Text(inspiration.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                        startPoint: .bottom,
                        endPoint: .top
                    ))
                    .cornerRadius(8)
            }
            
            // 作者信息和互动数据
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
                
                Text(inspiration.author)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .imageScale(.small)
                
                Text("\(inspiration.likes)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Image(systemName: "message.fill")
                    .foregroundColor(.gray)
                    .imageScale(.small)
                    .padding(.leading, 8)
                
                Text("\(inspiration.comments)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 4)
            
            // 内容简介
            Text(inspiration.content)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(3)
                .padding(.horizontal, 4)
            
            // 标签
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(inspiration.tags, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.vertical, 10)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.bottom, 10)
    }
}

// 小红书灵感详情页
struct RedBookInspirationDetailView: View {
    let inspiration: RedBookInspiration
    @Environment(\.presentationMode) var presentationMode
    @State private var commentText = ""
    @State private var showComments = false
    @State private var sampleComments = [
        Comment(author: "旅行爱好者", content: "太赞了！已经加入我的旅行清单～", time: "2小时前", likes: 24),
        Comment(author: "摄影达人", content: "请问用什么相机拍的？效果真好！", time: "3小时前", likes: 15),
        Comment(author: "美食家", content: "这家店的特色菜是什么呢？有推荐吗？", time: "5小时前", likes: 9),
        Comment(author: "背包客", content: "请问这个季节去合适吗？有什么特别需要注意的？", time: "1天前", likes: 32)
    ]
    @State private var showCopiedMessage = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 顶部图片区域
                ZStack(alignment: .topLeading) {
                    // 使用真实图片
                    if let uiImage = UIImage(named: inspiration.imageURL) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                    } else {
                        // 备用渐变背景
                        LinearGradient(
                            gradient: Gradient(colors: inspiration.colorScheme.gradient),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 300)
                        
                        // 中央图标
                        Image(systemName: inspiration.colorScheme.icon)
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    
                    // 返回按钮
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(16)
                            .background(Circle().fill(Color.black.opacity(0.3)))
                            .padding(.top, 40)
                            .padding(.leading, 16)
                    }
                }
                
                // 标题和作者信息
                VStack(alignment: .leading, spacing: 12) {
                    Text(inspiration.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text(inspiration.author)
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            // 关注作者
                        }) {
                            Text("关注")
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 内容详情
                    VStack(alignment: .leading) {
                        Text(inspiration.content)
                            .font(.body)
                            .lineSpacing(6)
                        
                        // 添加复制按钮
                        Button(action: {
                            // 复制内容到剪贴板
                            UIPasteboard.general.string = inspiration.content
                            showCopiedMessage = true
                            
                            // 2秒后隐藏提示
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showCopiedMessage = false
                            }
                        }) {
                            Label("复制攻略", systemImage: "doc.on.doc")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(inspiration.colorScheme.gradient[0])
                                .cornerRadius(8)
                        }
                        .padding(.top, 8)
                        
                        // 复制成功提示
                        if showCopiedMessage {
                            Text("攻略已复制到剪贴板")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 标签
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(inspiration.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 互动区域
                    HStack(spacing: 24) {
                        Button(action: {
                            // 点赞功能
                        }) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                Text("\(inspiration.likes)")
                                    .font(.subheadline)
                            }
                        }
                        
                        Button(action: {
                            showComments.toggle()
                        }) {
                            HStack {
                                Image(systemName: "message.fill")
                                    .foregroundColor(.gray)
                                Text("\(inspiration.comments)")
                                    .font(.subheadline)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 收藏功能
                        }) {
                            Image(systemName: "bookmark")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {
                            // 分享功能
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 评论区域
                    if showComments {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("热门评论")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(sampleComments) { comment in
                                CommentRow(comment: comment)
                            }
                            
                            // 添加评论
                            HStack {
                                TextField("添加评论...", text: $commentText)
                                    .padding(10)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(20)
                                
                                Button(action: {
                                    // 提交评论
                                    if !commentText.isEmpty {
                                        sampleComments.insert(Comment(author: "我", content: commentText, time: "刚刚", likes: 0), at: 0)
                                        commentText = ""
                                    }
                                }) {
                                    Image(systemName: "paperplane.fill")
                                        .foregroundColor(commentText.isEmpty ? .gray : .blue)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                        .padding(.bottom, 16)
                    }
                    
                    // 相关攻略推荐
                    Text("相关推荐")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<3) { i in
                                VStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(inspiration.colorScheme.gradient[0].opacity(0.8))
                                        .frame(width: 200, height: 120)
                                        .overlay(
                                            Text("相关攻略 \(i + 1)")
                                                .foregroundColor(.white)
                                                .font(.headline)
                                        )
                                    
                                    Text("发现更多\(inspiration.tags[i % inspiration.tags.count])的精彩")
                                        .font(.caption)
                                        .lineLimit(2)
                                        .frame(width: 200)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}

// 评论模型
struct Comment: Identifiable {
    let id = UUID()
    let author: String
    let content: String
    let time: String
    let likes: Int
}

// 评论行组件
struct CommentRow: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
                
                Text(comment.author)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(comment.time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(comment.content)
                .font(.subheadline)
                .padding(.leading, 4)
            
            HStack {
                Spacer()
                
                Button(action: {
                    // 评论点赞
                }) {
                    HStack {
                        Image(systemName: "heart")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("\(comment.likes)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Button(action: {
                    // 回复评论
                }) {
                    Text("回复")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    HomeView()
} 
