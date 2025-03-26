//
//  GuideDetailView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI

struct GuideDetailView: View {
    let guide: TravelGuide
    @State private var isFavorite: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 顶部大图
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
                    .frame(height: 250)
                    
                    // 中央图标
                    Image(systemName: iconForDestination(guide.destination))
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    
                    // 目的地标签
                    VStack {
                        HStack {
                            Text(guide.destination)
                                .font(.subheadline)
                                .padding(8)
                                .background(Color.black.opacity(0.6))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.leading)
                                .padding(.top)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                
                // 攻略标题和作者信息
                VStack(alignment: .leading, spacing: 10) {
                    Text(guide.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.gray)
                        
                        Text(guide.author)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            isFavorite.toggle()
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .gray)
                        }
                        
                        Text("\(guide.likes)")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // 攻略内容
                VStack(alignment: .leading, spacing: 15) {
                    Text("行程概览")
                        .font(.headline)
                    
                    Text("本攻略为\(guide.destination)7日游完整行程规划，包含交通、住宿、景点及美食推荐，适合初次前往\(guide.destination)的旅行者参考。")
                        .foregroundColor(.secondary)
                    
                    // 行程日程表
                    dayItinerary(day: 1, title: "抵达与市区观光", activities: ["抵达\(guide.destination)，办理入住", "参观市中心地标", "品尝当地特色晚餐"])
                    
                    dayItinerary(day: 2, title: "历史文化探索", activities: ["参观博物馆", "历史街区漫步", "传统美食体验"])
                    
                    dayItinerary(day: 3, title: "自然风光", activities: ["前往著名自然景点", "户外活动", "观景台欣赏城市全景"])
                    
                    dayItinerary(day: 4, title: "购物与休闲", activities: ["特色商场购物", "当地市场探索", "品尝特色小吃"])
                    
                    dayItinerary(day: 5, title: "周边一日游", activities: ["乘车前往周边热门景点", "特色体验活动", "返回市区"])
                    
                    Text("· 第6-7天行程请点击\"查看完整攻略\"按钮获取")
                        .italic()
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                }
                .padding(.horizontal)
                
                Divider()
                
                // 交通与住宿提示
                VStack(alignment: .leading, spacing: 15) {
                    Text("交通与住宿提示")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "airplane")
                            .frame(width: 30)
                        Text("国际航班直飞\(guide.destination)，飞行时间约为5-7小时")
                    }
                    
                    HStack {
                        Image(systemName: "tram.fill")
                            .frame(width: 30)
                        Text("\(guide.destination)公共交通发达，建议购买交通卡")
                    }
                    
                    HStack {
                        Image(systemName: "bed.double.fill")
                            .frame(width: 30)
                        Text("推荐住宿区域：市中心、观光区附近")
                    }
                    
                    // 地点之间交通方式
                    VStack(alignment: .leading, spacing: 10) {
                        Text("地点之间交通方式")
                            .font(.headline)
                            .padding(.top, 5)
                        
                        if guide.destination.contains("东京") {
                            transportBetweenLocations("成田机场", "东京市区", "机场快线", "60分钟", "¥3000", "airplane.departure")
                            transportBetweenLocations("东京站", "浅草寺", "地铁", "20分钟", "¥240", "subway.fill")
                            transportBetweenLocations("新宿", "富士山", "巴士", "2小时", "¥2500", "bus.fill")
                            transportBetweenLocations("东京", "京都", "新干线", "2.5小时", "¥13000", "tram")
                        } else if guide.destination.contains("巴黎") {
                            transportBetweenLocations("戴高乐机场", "巴黎市区", "RER B线", "35分钟", "€10.3", "airplane.departure")
                            transportBetweenLocations("埃菲尔铁塔", "卢浮宫", "地铁", "15分钟", "€1.9", "subway.fill")
                            transportBetweenLocations("巴黎", "凡尔赛宫", "RER C线", "40分钟", "€4.2", "tram")
                            transportBetweenLocations("巴黎", "卢瓦尔河谷", "火车", "1小时", "€45", "train.side.front.car")
                        } else if guide.destination.contains("纽约") {
                            transportBetweenLocations("肯尼迪机场", "曼哈顿", "AirTrain+地铁", "60分钟", "$10.75", "airplane.departure")
                            transportBetweenLocations("时代广场", "中央公园", "地铁", "10分钟", "$2.75", "subway.fill")
                            transportBetweenLocations("纽约", "华盛顿特区", "Amtrak", "3.5小时", "$100", "train.side.front.car")
                            transportBetweenLocations("曼哈顿", "布鲁克林", "地铁", "20分钟", "$2.75", "subway.fill")
                        } else if guide.destination.contains("泰国") {
                            transportBetweenLocations("素万那普机场", "曼谷市区", "机场轨道", "30分钟", "฿45", "airplane.departure")
                            transportBetweenLocations("曼谷", "清迈", "国内航班", "1小时", "฿1200", "airplane")
                            transportBetweenLocations("清迈市区", "双龙寺", "嘟嘟车", "30分钟", "฿200", "car.fill")
                            transportBetweenLocations("曼谷", "芭提雅", "巴士", "2小时", "฿120", "bus.fill")
                        } else {
                            transportBetweenLocations("机场", "市中心", "机场快线", "45分钟", "¥120", "airplane.departure")
                            transportBetweenLocations("市中心", "主要景点", "地铁", "30分钟", "¥10", "subway.fill")
                            transportBetweenLocations("城市A", "城市B", "高铁", "2小时", "¥300", "tram")
                            transportBetweenLocations("市区", "郊区景点", "公交车", "1小时", "¥20", "bus.fill")
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // 底部操作按钮
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // 分享功能
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("分享攻略")
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // 查看完整攻略
                    }) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                            Text("查看完整攻略")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // 行程日程表组件
    private func dayItinerary(day: Int, title: String, activities: [String]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("第\(day)天")
                    .font(.headline)
                    .padding(5)
                    .background(colorForDestination(guide.destination).opacity(0.2))
                    .cornerRadius(5)
                
                Text(title)
                    .fontWeight(.semibold)
            }
            
            ForEach(activities, id: \.self) { activity in
                HStack(alignment: .top) {
                    Text("•")
                        .foregroundColor(.secondary)
                    Text(activity)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 5)
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
    
    // 地点之间交通方式组件
    private func transportBetweenLocations(_ from: String, _ to: String, _ mode: String, _ duration: String, _ cost: String, _ icon: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 5) {
                Text("\(from) 到 \(to)")
                    .font(.headline)
                
                Text("\(mode)，约\(duration)，\(formatCurrencyText(cost))")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // 货币文本格式化辅助函数
    private func formatCurrencyText(_ cost: String) -> String {
        if cost.hasPrefix("¥") {
            return "日元约\(cost)"
        } else if cost.hasPrefix("€") {
            return "欧元约\(cost)"
        } else if cost.hasPrefix("$") {
            return "美元约\(cost)"
        } else if cost.hasPrefix("฿") {
            return "泰铢约\(cost)"
        } else {
            return "费用约\(cost)"
        }
    }
}

#Preview {
    NavigationView {
        GuideDetailView(guide: TravelGuide(
            title: "东京7日游完全攻略",
            destination: "日本东京",
            imageURL: "tokyo",
            author: "旅行达人",
            likes: 1243
        ))
    }
} 
