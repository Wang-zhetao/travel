//
//  TransportationView.swift
//  TravelGuide
//
//  Created on 2025/3/30.
//

import SwiftUI

struct TransportationView: View {
    // 状态变量
    @State private var selectedTransportType = 0
    @State private var searchText = ""
    @State private var showingCardOptions = false
    @State private var selectedCity = "北京"
    
    // 城市和交通卡数据
    let cities = ["北京", "上海", "广州", "深圳", "杭州", "成都", "重庆", "西安"]
    let transportCards = [
        "北京": ["亿通行", "北京一卡通"],
        "上海": ["Metro大都会", "上海交通卡"],
        "广州": ["羊城通", "岭南通"],
        "深圳": ["深圳通", "粤通卡"],
        "杭州": ["杭州通", "钱江通"],
        "成都": ["天府通", "成都公交卡"],
        "重庆": ["重庆畅通卡", "渝城通"],
        "西安": ["长安通", "西安公交卡"]
    ]
    
    // 高铁数据示例
    let trainRoutes = [
        TrainRoute(from: "北京", to: "上海", trainNumber: "G1", departureTime: "08:00", arrivalTime: "12:38", price: "553", remainingTickets: 12),
        TrainRoute(from: "北京", to: "广州", trainNumber: "G71", departureTime: "09:15", arrivalTime: "16:52", price: "862", remainingTickets: 5),
        TrainRoute(from: "上海", to: "杭州", trainNumber: "G7305", departureTime: "10:05", arrivalTime: "10:52", price: "73", remainingTickets: 28),
        TrainRoute(from: "广州", to: "深圳", trainNumber: "G6138", departureTime: "11:30", arrivalTime: "12:10", price: "82", remainingTickets: 0)
    ]
    
    // 地铁拥挤度数据
    let metroLines = [
        MetroLine(city: "北京", line: "10号线", stations: [
            MetroStation(name: "芍药居", congestionLevel: .high, peakHours: "7:30-9:00, 17:30-19:00"),
            MetroStation(name: "太阳宫", congestionLevel: .medium, peakHours: "8:00-9:00, 18:00-19:00"),
            MetroStation(name: "三元桥", congestionLevel: .high, peakHours: "7:30-9:30, 17:30-19:30")
        ]),
        MetroLine(city: "上海", line: "2号线", stations: [
            MetroStation(name: "人民广场", congestionLevel: .high, peakHours: "7:30-9:30, 17:00-19:00"),
            MetroStation(name: "南京东路", congestionLevel: .medium, peakHours: "8:00-9:00, 17:30-18:30")
        ])
    ]
    
    // 共享出行数据
    let sharedTransportOptions = [
        SharedTransport(type: "单车", provider: "美团单车", estimatedPrice: "1.5元/30分钟", estimatedTime: "15分钟"),
        SharedTransport(type: "单车", provider: "哈啰单车", estimatedPrice: "1.5元/30分钟", estimatedTime: "15分钟"),
        SharedTransport(type: "网约车", provider: "滴滴出行", estimatedPrice: "15元", estimatedTime: "5分钟"),
        SharedTransport(type: "网约车", provider: "高德打车", estimatedPrice: "14元", estimatedTime: "7分钟")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 顶部选择器
                Picker("交通类型", selection: $selectedTransportType) {
                    Text("高铁抢票").tag(0)
                    Text("地铁出行").tag(1)
                    Text("共享出行").tag(2)
                    Text("交通卡").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // 搜索栏
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("搜索目的地、车次或站点", text: $searchText)
                        .font(.system(size: 16))
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // 根据选择显示不同内容
                switch selectedTransportType {
                case 0:
                    highSpeedRailView
                case 1:
                    metroView
                case 2:
                    sharedTransportView
                case 3:
                    transportCardView
                default:
                    EmptyView()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("交通出行")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // 高铁抢票视图
    private var highSpeedRailView: some View {
        VStack(spacing: 16) {
            // 出发地-目的地选择
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("出发")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("北京")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .frame(width: 100, alignment: .leading)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 20))
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading) {
                    Text("到达")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("上海")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .frame(width: 100, alignment: .leading)
                
                Spacer()
                
                Button(action: {
                    // 交换出发地和目的地
                }) {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                        .padding(8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            // 日期选择
            HStack {
                VStack(alignment: .leading) {
                    Text("出发日期")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("2025年3月31日")
                        .font(.headline)
                }
                
                Spacer()
                
                Button(action: {
                    // 显示日期选择器
                }) {
                    Text("更改")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            // 查询按钮
            Button(action: {
                // 执行查询
            }) {
                Text("查询车票")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // 高铁车次列表
            VStack(spacing: 15) {
                HStack {
                    Text("车次信息")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("北京 → 上海")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Divider()
                
                ForEach(trainRoutes) { route in
                    trainRouteCard(route)
                }
            }
            .padding(.top, 10)
            .background(Color(UIColor.systemGray6).opacity(0.5))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // 候补排队提示
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundColor(.orange)
                
                Text("开启候补排队提醒，有票自动通知")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    // 单个高铁车次卡片
    private func trainRouteCard(_ route: TrainRoute) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                // 左侧时间和车次信息
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(route.departureTime)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text(route.from)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text(route.trainNumber)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                        
                        Text("历时4小时38分")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // 中间箭头
                VStack {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 右侧到达时间和价格
                VStack(alignment: .trailing, spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(route.to)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(route.arrivalTime)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("二等座")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("¥\(route.price)")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            Divider()
                .padding(.horizontal)
            
            // 底部操作按钮
            HStack {
                Text(route.remainingTickets > 0 ? "余票\(route.remainingTickets)张" : "无票")
                    .font(.subheadline)
                    .foregroundColor(route.remainingTickets > 0 ? .green : .red)
                
                Spacer()
                
                Button(action: {
                    // 预订或候补
                }) {
                    Text(route.remainingTickets > 0 ? "预订" : "候补")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(route.remainingTickets > 0 ? Color.orange : Color.blue)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // 地铁出行视图
    private var metroView: some View {
        VStack(spacing: 16) {
            // 城市选择
            HStack {
                Text("当前城市:")
                    .font(.headline)
                
                Picker("选择城市", selection: $selectedCity) {
                    ForEach(cities, id: \.self) { city in
                        Text(city).tag(city)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            
            // 地铁线路信息
            ForEach(metroLines.filter { $0.city == selectedCity }) { line in
                metroLineView(line: line)
            }
            
            // 地铁路线规划
            Button(action: {
                // 打开地铁路线规划
            }) {
                HStack {
                    Image(systemName: "map.fill")
                        .foregroundColor(.white)
                    
                    Text("地铁路线规划")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
    
    // 地铁线路视图
    private func metroLineView(line: MetroLine) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(line.city + " " + line.line)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.blue)
                    .cornerRadius(5)
                
                Spacer()
                
                Text("实时拥挤度")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            ForEach(line.stations) { station in
                metroStationView(station: station, isLast: station == line.stations.last)
            }
            
            // 高峰时段提示
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                
                Text("高峰时段建议避开芍药居站")
                    .font(.caption)
                    .foregroundColor(.orange)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // 地铁站视图
    private func metroStationView(station: MetroStation, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(station.name)
                    .font(.subheadline)
                
                Spacer()
                
                HStack(spacing: 5) {
                    // 拥挤度指示器
                    congestionIndicator(level: station.congestionLevel)
                    
                    Text(station.congestionLevelDescription)
                        .font(.caption)
                        .foregroundColor(station.congestionLevelColor)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            if !isLast {
                Divider()
                    .padding(.horizontal)
            }
        }
    }
    
    // 拥挤度指示器
    private func congestionIndicator(level: CongestionLevel) -> some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(i < level.rawValue ? Color.red : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    // 共享出行视图
    private var sharedTransportView: some View {
        VStack(spacing: 16) {
            // 起点终点选择
            locationSelectionView
            
            // 距离和费用比较
            transportComparisonView
            
            // 价格比较提示
            priceComparisonTipView
        }
    }
    
    // 位置选择视图
    private var locationSelectionView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "location.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                
                Text("当前位置")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    // 更改位置
                }) {
                    Text("更改")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                
                Text("目的地")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    // 选择目的地
                }) {
                    Text("选择")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // 交通比较视图
    private var transportComparisonView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("出行方式比较 (3公里)")
                .font(.headline)
                .padding(.horizontal)
            
            Divider()
            
            ForEach(sharedTransportOptions) { option in
                transportOptionView(option: option)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // 单个交通选项视图
    private func transportOptionView(option: SharedTransport) -> some View {
        VStack(spacing: 0) {
            HStack {
                // 图标
                Image(systemName: option.type == "单车" ? "bicycle" : "car.fill")
                    .foregroundColor(option.type == "单车" ? .green : .blue)
                    .font(.title3)
                    .frame(width: 40)
                
                // 提供商和价格
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.provider)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("预计费用: \(option.estimatedPrice)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 预计时间和呼叫按钮
                VStack(alignment: .trailing, spacing: 4) {
                    Text("预计\(option.estimatedTime)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    callButton(for: option)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            
            if option != sharedTransportOptions.last {
                Divider()
                    .padding(.horizontal)
            }
        }
    }
    
    // 呼叫按钮
    private func callButton(for option: SharedTransport) -> some View {
        Button(action: {
            // 调用服务
        }) {
            Text("呼叫")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(option.type == "单车" ? Color.green : Color.blue)
                .cornerRadius(12)
        }
    }
    
    // 价格比较提示视图
    private var priceComparisonTipView: some View {
        HStack {
            Image(systemName: "dollarsign.circle.fill")
                .foregroundColor(.green)
            
            Text("3公里内: 单车1.5元 vs 网约车15元")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    // 交通卡视图
    private var transportCardView: some View {
        VStack(spacing: 16) {
            // 城市选择
            HStack {
                Text("当前城市:")
                    .font(.headline)
                
                Picker("选择城市", selection: $selectedCity) {
                    ForEach(cities, id: \.self) { city in
                        Text(city).tag(city)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            
            // 推荐交通卡
            VStack(alignment: .leading, spacing: 10) {
                Text("推荐交通卡")
                    .font(.headline)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                if let cityCards = transportCards[selectedCity] {
                    ForEach(cityCards, id: \.self) { card in
                        transportCardItem(card: card)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            
            // 充值选项
            VStack(alignment: .leading, spacing: 10) {
                Text("快捷充值")
                    .font(.headline)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                HStack(spacing: 15) {
                    // 支付宝充值
                    Button(action: {
                        // 支付宝充值
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "creditcard.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            Text("支付宝")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // 微信充值
                    Button(action: {
                        // 微信充值
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "creditcard.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            Text("微信支付")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            
            // 免密支付提示
            HStack {
                Image(systemName: "lock.open.fill")
                    .foregroundColor(.orange)
                
                Text("已开启免密支付，余额不足自动充值")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    // 交通卡项目
    private func transportCardItem(card: String) -> some View {
        HStack {
            // 卡片图标
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 50, height: 50)
                
                Text(String(card.prefix(1)))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // 卡片信息
            VStack(alignment: .leading, spacing: 4) {
                Text(card)
                    .font(.headline)
                
                Text("余额: ¥35.50")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 操作按钮
            Button(action: {
                showingCardOptions = true
            }) {
                Text("管理")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.5))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// 数据模型
struct TrainRoute: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let trainNumber: String
    let departureTime: String
    let arrivalTime: String
    let price: String
    let remainingTickets: Int
}

enum CongestionLevel: Int {
    case low = 1
    case medium = 2
    case high = 3
    
    var description: String {
        switch self {
        case .low: return "舒适"
        case .medium: return "一般"
        case .high: return "拥挤"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

struct MetroStation: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let congestionLevel: CongestionLevel
    let peakHours: String
    
    var congestionLevelDescription: String {
        return congestionLevel.description
    }
    
    var congestionLevelColor: Color {
        return congestionLevel.color
    }
    
    static func == (lhs: MetroStation, rhs: MetroStation) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MetroLine: Identifiable {
    let id = UUID()
    let city: String
    let line: String
    let stations: [MetroStation]
}

struct SharedTransport: Identifiable, Equatable {
    let id = UUID()
    let type: String
    let provider: String
    let estimatedPrice: String
    let estimatedTime: String
    
    static func == (lhs: SharedTransport, rhs: SharedTransport) -> Bool {
        return lhs.id == rhs.id
    }
}

#Preview {
    NavigationView {
        TransportationView()
    }
}
