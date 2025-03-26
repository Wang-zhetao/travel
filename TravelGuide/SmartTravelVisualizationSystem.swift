//
//  SmartTravelVisualizationSystem.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI
import MapKit

// 地点模型
struct Location: Identifiable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: LocationType
    let timeSpent: Int // 预计停留时间（分钟）
    let openingHours: String?
    var notes: String = ""
    var address: String = ""
    var cost: Double = 0 // 消费预算
    var priority: Bool = false // 是否为优先景点
    
    enum LocationType: String, CaseIterable {
        case attraction = "景点"
        case restaurant = "餐厅"
        case hotel = "住宿"
        case shopping = "购物"
        case transport = "交通"
        case activity = "活动"
        case other = "其他"
    }
}

// 交通方式模型
struct TravelMode: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let speedFactor: Double // 速度因子，影响路线规划
    let costPerKm: Double // 每公里成本
    let carbonFootprint: Double // 碳足迹指数
    let comfortLevel: Int // 舒适度 1-5, 5最舒适
    
    // 交通方式预设
    static let walking = TravelMode(
        id: "walking",
        name: "步行", 
        icon: "figure.walk", 
        color: .green, 
        speedFactor: 1.0, 
        costPerKm: 0, 
        carbonFootprint: 0, 
        comfortLevel: 3
    )
    static let publicTransport = TravelMode(
        id: "publicTransport",
        name: "公共交通", 
        icon: "tram.fill", 
        color: .blue, 
        speedFactor: 3.0, 
        costPerKm: 0.5, 
        carbonFootprint: 0.3, 
        comfortLevel: 2
    )
    static let taxi = TravelMode(
        id: "taxi",
        name: "出租车", 
        icon: "car.fill", 
        color: .orange, 
        speedFactor: 4.0, 
        costPerKm: 2.5, 
        carbonFootprint: 0.7, 
        comfortLevel: 4
    )
    static let bicycle = TravelMode(
        id: "bicycle",
        name: "自行车", 
        icon: "bicycle", 
        color: .teal, 
        speedFactor: 2.0, 
        costPerKm: 0.1, 
        carbonFootprint: 0.1, 
        comfortLevel: 3
    )
    static let highSpeedRail = TravelMode(
        id: "highSpeedRail",
        name: "高铁", 
        icon: "tram", 
        color: .red, 
        speedFactor: 15.0, 
        costPerKm: 0.5, 
        carbonFootprint: 0.2, 
        comfortLevel: 4
    )
    static let flight = TravelMode(
        id: "flight",
        name: "飞机", 
        icon: "airplane", 
        color: .purple, 
        speedFactor: 25.0, 
        costPerKm: 1.2, 
        carbonFootprint: 1.0, 
        comfortLevel: 3
    )
    
    static let localModes = [walking, publicTransport, taxi, bicycle]
    static let longDistanceModes = [highSpeedRail, flight]
    static let allModes = localModes + longDistanceModes
}

// 行程模型
struct TravelItinerary: Identifiable {
    let id: String
    let name: String
    var startDate: Date
    var endDate: Date
    var locations: [ItineraryLocation]
    var totalBudget: Double
    var optimizationPreference: OptimizationPreference
    
    enum OptimizationPreference {
        case timeEfficient // 时间最短
        case costEffective // 成本最低
        case experienceOptimal // 体验最佳
        case balanced // 平衡模式
    }
}

// 行程中的地点，包含前后交通衔接信息
struct ItineraryLocation: Identifiable {
    let id: String
    var location: Location
    var plannedArrivalTime: Date
    var plannedDepartureTime: Date
    var transportToHere: TransportSegment?
    var transportFromHere: TransportSegment?
    var status: VisitStatus = .planned
    
    enum VisitStatus {
        case planned
        case visited
        case skipped
        case delayed
    }
}

// 交通段落
struct TransportSegment: Identifiable {
    let id: String
    var mode: TravelMode
    var startLocation: Location
    var endLocation: Location
    var distance: Double // 公里
    var estimatedDuration: TimeInterval // 预计耗时（秒）
    var cost: Double // 预计花费
    var departureTime: Date
    var arrivalTime: Date
    var trafficCondition: TrafficCondition = .normal
    
    enum TrafficCondition {
        case light
        case normal
        case heavy
        case severe
    }
}

// 天气信息模型
struct WeatherInfo {
    let temperature: Double
    let condition: WeatherCondition
    let precipitation: Double // 降水概率 0-1
    let windSpeed: Double
    let humidity: Double
    
    enum WeatherCondition: String {
        case sunny = "晴朗"
        case cloudy = "多云"
        case rainy = "雨天"
        case snowy = "雪天"
        case foggy = "雾天"
        case windy = "大风"
        case stormy = "暴风雨"
    }
    
    var icon: String {
        switch condition {
        case .sunny: return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .snowy: return "cloud.snow.fill"
        case .foggy: return "cloud.fog.fill"
        case .windy: return "wind"
        case .stormy: return "cloud.bolt.rain.fill"
        }
    }
    
    var color: Color {
        switch condition {
        case .sunny: return .yellow
        case .cloudy: return .gray
        case .rainy: return .blue
        case .snowy: return .white
        case .foggy: return .gray
        case .windy: return .cyan
        case .stormy: return .purple
        }
    }
}

// 交通信息模型
struct TrafficInfo {
    let congestionLevel: CongestionLevel
    let avgSpeed: Double // km/h
    let incidentCount: Int
    let description: String
    
    enum CongestionLevel: Int {
        case light = 1
        case moderate = 2
        case heavy = 3
        case severe = 4
        
        var description: String {
            switch self {
            case .light: return "畅通"
            case .moderate: return "轻微拥堵"
            case .heavy: return "中度拥堵"
            case .severe: return "严重拥堵"
            }
        }
        
        var color: Color {
            switch self {
            case .light: return .green
            case .moderate: return .yellow
            case .heavy: return .orange
            case .severe: return .red
            }
        }
    }
}

// 行程冲突模型
struct TravelConflict: Identifiable {
    let id = UUID()
    let type: ConflictType
    let description: String
    let affectedLocations: [Location]
    let suggestedSolution: String
    
    enum ConflictType {
        case timeOverlap
        case distanceFeasibility
        case openingHours
        case budgetExceeded
        case trafficDelay
    }
}

// 智能行程可视化系统主视图
struct SmartTravelVisualizationSystem: View {
    // 状态变量
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503), // 东京
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var selectedLocation: Location?
    @State private var showingLocationDetails = false
    @State private var route: [Location] = []
    @State private var mapType: MKMapType = .standard
    @State private var showingAddLocationSheet = false
    
    // 添加位置表单相关状态
    @State private var newLocationName = ""
    @State private var newLocationType: Location.LocationType = .attraction
    @State private var newLocationTimeSpent = 60
    @State private var newLocationAddress = ""
    @State private var newLocationCost = ""
    @State private var newLocationPriority = false
    @State private var newLocationOpenTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var newLocationCloseTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var newLocationNotes = ""
    
    @State private var tapLocation: CLLocationCoordinate2D?
    @State private var selectedTravelMode: TravelMode = TravelMode.publicTransport
    @State private var showTravelModeSelection = false
    @State private var totalTravelTime: TimeInterval = 0
    @State private var totalDistance: Double = 0
    @State private var showingRouteStats = false
    @State private var optimizationMethod = 0 // 0: 最短路径, 1: 最少时间, 2: 平衡模式
    
    // 新增状态变量
    @State private var viewMode: ViewMode = .map
    @State private var currentItinerary: TravelItinerary?
    @State private var itineraries: [TravelItinerary] = []
    @State private var showingConflicts = false
    @State private var conflicts: [TravelConflict] = []
    @State private var weatherData: [String: WeatherInfo] = [:]
    @State private var trafficData: [String: TrafficInfo] = [:]
    @State private var selectedDate: Date = Date()
    @State private var isShowingTimelineView = false
    @State private var isLoadingData = false
    @State private var optimizationPreference: TravelItinerary.OptimizationPreference = .balanced
    @State private var showWeatherInfo = false
    
    enum ViewMode {
        case map
        case timeline
        case list
        case statistics
    }
    
    // 示例位置数据
    @State private var sampleLocations: [Location] = [
        Location(
            id: UUID().uuidString,
            name: "东京塔", 
            coordinate: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
            type: .attraction,
            timeSpent: 120, // 2小时
            openingHours: "9:00-23:00",
            notes: "东京地标，可以俯瞰全市美景",
            address: "东京都港区芝公园4-2-8",
            cost: 1000, // 日元
            priority: true
        ),
        Location(
            id: UUID().uuidString,
            name: "浅草寺",
            coordinate: CLLocationCoordinate2D(latitude: 35.7147, longitude: 139.7966),
            type: .attraction,
            timeSpent: 90, // 1.5小时
            openingHours: "6:00-17:00",
            notes: "东京最古老的寺庙，体验传统日本文化",
            address: "东京都台东区浅草2-3-1",
            cost: 0, // 免费
            priority: true
        ),
        Location(
            id: UUID().uuidString,
            name: "寿司大", 
            coordinate: CLLocationCoordinate2D(latitude: 35.6954, longitude: 139.7019),
            type: .restaurant,
            timeSpent: 60, // 1小时
            openingHours: "11:00-22:00",
            notes: "顶级寿司店，需提前预约",
            address: "东京都中央区银座4-2-15",
            cost: 12000, // 日元
            priority: false
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部控制条
                topControlBar
                
                ZStack {
                    // 主要内容视图 - 根据视图模式切换
                    switch viewMode {
                    case .map:
                        mapView
                    case .timeline:
                        timelineView
                    case .list:
                        itineraryListView
                    case .statistics:
                        statisticsView
                    }
                    
                    // 浮动控制和提示
                    VStack {
                        if showingConflicts && !conflicts.isEmpty {
                            conflictAlertView
                        }
                        
                        Spacer()
                        
                        if viewMode == .map && !route.isEmpty {
                            bottomRouteInfoPanel
                        }
                    }
                    
                    // 加载指示器
                    if isLoadingData {
                        loadingView
                    }
                }
            }
            .navigationTitle("智能行程")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: { showNewItinerarySheet() }) {
                    Label("新建", systemImage: "plus")
                },
                trailing: HStack {
                    Button(action: { optimizeCurrentItinerary() }) {
                        Image(systemName: "wand.and.stars")
                    }
                    
                    Button(action: { showItinerarySettings() }) {
                        Image(systemName: "gear")
                    }
                }
            )
            .sheet(isPresented: $showingLocationDetails) {
                if let location = selectedLocation {
                    LocationDetailView(location: location)
                }
            }
            .sheet(isPresented: $showingAddLocationSheet) {
                addLocationView
            }
            .alert(isPresented: $showingConflicts) {
                Alert(
                    title: Text("行程冲突"),
                    message: Text(conflicts.first?.description ?? "您的行程存在冲突，建议调整。"),
                    primaryButton: .default(Text("查看详情")) {
                        // 显示冲突详情
                    },
                    secondaryButton: .cancel(Text("忽略"))
                )
            }
        }
    }
    
    // MARK: - 子视图组件
    
    // 顶部控制栏
    private var topControlBar: some View {
        HStack(spacing: 16) {
            // 视图模式切换
            Picker("视图模式", selection: $viewMode) {
                Image(systemName: "map").tag(ViewMode.map)
                Image(systemName: "timeline.selection").tag(ViewMode.timeline)
                Image(systemName: "list.bullet").tag(ViewMode.list)
                Image(systemName: "chart.bar").tag(ViewMode.statistics)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
            
            Spacer()
            
            // 日期选择器
            DatePicker(
                "选择日期",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .labelsHidden()
            .datePickerStyle(CompactDatePickerStyle())
            
            // 优化首选项
            Menu {
                Button(action: { optimizationPreference = .timeEfficient }) {
                    Label("时间优先", systemImage: "clock")
                    if optimizationPreference == .timeEfficient {
                        Image(systemName: "checkmark")
                    }
                }
                
                Button(action: { optimizationPreference = .costEffective }) {
                    Label("成本优先", systemImage: "dollarsign.circle")
                    if optimizationPreference == .costEffective {
                        Image(systemName: "checkmark")
                    }
                }
                
                Button(action: { optimizationPreference = .experienceOptimal }) {
                    Label("体验优先", systemImage: "star")
                    if optimizationPreference == .experienceOptimal {
                        Image(systemName: "checkmark")
                    }
                }
                
                Button(action: { optimizationPreference = .balanced }) {
                    Label("平衡模式", systemImage: "equal.circle")
                    if optimizationPreference == .balanced {
                        Image(systemName: "checkmark")
                    }
                }
            } label: {
                Label(optimizationPreferenceLabel, systemImage: optimizationPreferenceIcon)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .shadow(radius: 2)
    }
    
    // 加载视图
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text("AI正在生成最优行程...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.7))
            )
        }
    }
    
    // 冲突提示视图
    private var conflictAlertView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                
                Text("行程冲突提醒")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { showingConflicts = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            ForEach(conflicts.prefix(2), id: \.description) { conflict in
                HStack(alignment: .top) {
                    Image(systemName: conflictTypeIcon(conflict.type))
                        .foregroundColor(.orange)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading) {
                        Text(conflict.description)
                            .font(.subheadline)
                        
                        Text(conflict.suggestedSolution)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if conflicts.count > 2 {
                Text("还有\(conflicts.count - 2)个冲突...")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Button(action: { resolveConflictsAutomatically() }) {
                Text("自动解决冲突")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
        .transition(.move(edge: .top))
    }
    
    // 添加位置视图
    private var addLocationView: some View {
        NavigationView {
            Form {
                Section(header: Text("位置信息")) {
                    TextField("名称", text: $newLocationName)
                    
                    Picker("类型", selection: $newLocationType) {
                        ForEach(Location.LocationType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: iconForType(type))
                                .tag(type)
                        }
                    }
                    
                    HStack {
                        Text("预计停留时间")
                        Spacer()
                        Picker("", selection: $newLocationTimeSpent) {
                            ForEach([30, 60, 90, 120, 150, 180, 240], id: \.self) { minutes in
                                Text(formatDuration(minutes)).tag(minutes)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                Section(header: Text("详细信息")) {
                    TextField("地址", text: $newLocationAddress)
                    
                    HStack {
                        Text("费用")
                        Spacer()
                        TextField("", text: $newLocationCost)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("¥")
                    }
                    
                    Toggle("设为优先景点", isOn: $newLocationPriority)
                }
                
                Section(header: Text("营业时间")) {
                    DatePicker("开始时间", selection: $newLocationOpenTime, displayedComponents: .hourAndMinute)
                    DatePicker("结束时间", selection: $newLocationCloseTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("笔记")) {
                    TextEditor(text: $newLocationNotes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("添加新位置")
            .navigationBarItems(
                leading: Button("取消") {
                    showingAddLocationSheet = false
                },
                trailing: Button("添加") {
                    addNewLocation()
                    showingAddLocationSheet = false
                }
                .disabled(newLocationName.isEmpty)
            )
        }
    }
    
    // 地图视图
    private var mapView: some View {
        RouteMapView(
            region: region,
            locations: route.isEmpty ? sampleLocations : route,
            travelMode: selectedTravelMode,
            tapAction: { coordinate in
                showingAddLocationSheet = true
                tapLocation = coordinate
            },
            annotationTapAction: { location in
                selectedLocation = location
                showingLocationDetails = true
            },
            mapType: mapType,
            iconForType: { type in
                if let locationType = type as? Location.LocationType {
                    return iconForType(locationType)
                }
                return "mappin"
            },
            colorForType: { type in
                if let locationType = type as? Location.LocationType {
                    return colorForType(locationType)
                }
                return .red
            }
        )
        .overlay(
            VStack {
                HStack {
                    // 左侧控制按钮
                    mapControlPanel
                    
                    Spacer()
                    
                    // 地图模式与位置控制
                    mapModePanel
                }
                .padding(.top, 10)
                .padding(.horizontal)
                
                Spacer()
                
                // 底部生成路线面板
                if route.isEmpty {
                    routeGenerationPanel
                }
            }
        )
    }
    
    // MARK: - 地图子组件
    
    // 地图控制面板
    private var mapControlPanel: some View {
        VStack(spacing: 10) {
            Button(action: {
                withAnimation {
                    showTravelModeSelection.toggle()
                }
            }) {
                Image(systemName: selectedTravelMode.icon)
                    .padding(8)
                    .background(.white)
                    .foregroundColor(selectedTravelMode.color)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            
            if !route.isEmpty {
                Button(action: {
                    showingRouteStats.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .padding(8)
                        .background(.white)
                        .foregroundColor(.blue)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            }
            
            // 天气信息按钮
            Button(action: {
                showWeatherInfo = true
            }) {
                Image(systemName: "cloud.sun.fill")
                    .padding(8)
                    .background(.white)
                    .foregroundColor(.orange)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
        }
    }
    
    // 地图模式面板
    private var mapModePanel: some View {
        VStack(spacing: 10) {
            Button(action: {
                mapType = mapType == .standard ? .hybrid : .standard
            }) {
                Image(systemName: mapType == .standard ? "globe" : "map")
                    .padding(8)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            
            Button(action: {
                // 添加当前位置
                if let userLocation = CLLocationManager().location?.coordinate {
                    tapLocation = userLocation
                    showingAddLocationSheet = true
                }
            }) {
                Image(systemName: "plus")
                    .padding(8)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            
            Button(action: {
                // 重置地图视角到所有点
                if !route.isEmpty {
                    updateMapRegionToShowAllLocations()
                }
            }) {
                Image(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
                    .padding(8)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
        }
    }
    
    // 路线生成面板
    private var routeGenerationPanel: some View {
        VStack(spacing: 10) {
            Picker("优化方式", selection: $optimizationMethod) {
                Text("最短路径").tag(0)
                Text("最省时间").tag(1)
                Text("平衡模式").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .background(Color.white.opacity(0.8))
            .cornerRadius(8)
            
            Button(action: generateOptimalRoute) {
                Text("AI智能规划路线")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
        }
        .padding(.bottom)
        .padding(.horizontal)
        .background(Color.white.opacity(0.6))
        .cornerRadius(15)
        .padding(.bottom)
    }
    
    // 底部路线信息面板
    private var bottomRouteInfoPanel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(Array(route.enumerated()), id: \.element.id) { index, location in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(index + 1)")
                                .font(.caption)
                                .bold()
                                .padding(4)
                                .background(Circle().fill(Color.orange))
                                .foregroundColor(.white)
                            
                            Image(systemName: iconForType(location.type))
                                .foregroundColor(colorForType(location.type))
                            Text(location.name)
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Text(formatDuration(location.timeSpent))
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            if index < route.count - 1 {
                                Image(systemName: selectedTravelMode.icon)
                                    .font(.caption)
                                    .foregroundColor(selectedTravelMode.color)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
            }
            .padding()
        }
        .background(Color.white.opacity(0.9))
    }
    
    // 时间线视图
    private var timelineView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 当前日期标题
                Text(formattedDate(selectedDate))
                    .font(.headline)
                    .padding()
                
                // 时间线
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<24, id: \.self) { hour in
                        timelineHourRow(hour: hour)
                    }
                }
            }
        }
    }
    
    // 时间线小时行
    private func timelineHourRow(hour: Int) -> some View {
        let hourEvents = getEventsForHour(hour, on: selectedDate)
        
        return ZStack(alignment: .topLeading) {
            // 小时格子背景
            Rectangle()
                .fill(hour % 2 == 0 ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground))
                .frame(height: max(120, CGFloat(hourEvents.count * 60)))
            
            VStack(alignment: .leading, spacing: 0) {
                // 小时标签
                HStack {
                    Text(String(format: "%02d:00", hour))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(width: 50, alignment: .leading)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color.gray.opacity(0.3))
                        .padding(.leading, 8)
                }
                .padding(.vertical, 8)
                
                // 该小时的事件
                ForEach(hourEvents, id: \.name) { event in
                    timelineEventCard(event: event)
                        .padding(.leading, 58)
                        .padding(.vertical, 4)
                }
            }
        }
    }
    
    // 时间线事件卡片
    private func timelineEventCard(event: TimelineEvent) -> some View {
        HStack(spacing: 12) {
            // 事件类型图标
            ZStack {
                Circle()
                    .fill(event.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: event.icon)
                    .foregroundColor(event.color)
            }
            
            // 事件详情
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                
                Text(event.timeRange)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !event.details.isEmpty {
                    Text(event.details)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            // 交通方式图标
            if event.isTransport {
                Image(systemName: selectedTravelMode.icon)
                    .foregroundColor(selectedTravelMode.color)
                    .padding(8)
                    .background(selectedTravelMode.color.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    // 行程列表视图
    private var itineraryListView: some View {
        List {
            Section(header: Text("行程概览")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("东京4日游")
                        .font(.headline)
                    
                    HStack {
                        Label("4天3晚", systemImage: "calendar")
                            .font(.caption)
                        
                        Spacer()
                        
                        Label("12个地点", systemImage: "mappin.and.ellipse")
                            .font(.caption)
                        
                        Spacer()
                        
                        Label("¥120,000", systemImage: "yensign")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            Section(header: Text("日程安排")) {
                ForEach(0..<4) { day in
                    NavigationLink(destination: Text("第\(day+1)天详情")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("第\(day+1)天")
                                    .font(.headline)
                                
                                Text("3月\(day+1)日")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(3 + day)个地点")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            
            Section(header: Text("交通方式")) {
                ForEach(TravelMode.allModes) { mode in
                    HStack {
                        Image(systemName: mode.icon)
                            .foregroundColor(mode.color)
                        
                        Text(mode.name)
                        
                        Spacer()
                        
                        Text(String(format: "¥%.0f", mode.costPerKm * 10))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    // 统计视图
    private var statisticsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 行程总览卡片
                VStack(alignment: .leading, spacing: 16) {
                    Text("行程总览")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        statCard(value: "4天", title: "总天数", icon: "calendar")
                        statCard(value: "12", title: "地点", icon: "mappin")
                        statCard(value: "67.2km", title: "总距离", icon: "figure.walk")
                    }
                    
                    HStack(spacing: 20) {
                        statCard(value: "¥120,000", title: "总预算", icon: "yensign")
                        statCard(value: "18h", title: "观光时间", icon: "clock")
                        statCard(value: "6h", title: "交通时间", icon: "car")
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                
                // 成本分析
                VStack(alignment: .leading, spacing: 16) {
                    Text("成本分析")
                        .font(.headline)
                    
                    // 这里会放饼图或柱状图
                    HStack {
                        ForEach(["住宿", "餐饮", "交通", "景点", "购物"], id: \.self) { category in
                            VStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(categoryColor(category))
                                    .frame(height: CGFloat.random(in: 50...150))
                                
                                Text(category)
                                    .font(.caption)
                                    .fixedSize()
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    // 成本明细
                    VStack(spacing: 12) {
                        costRow(category: "住宿", amount: 45000, percentage: 37.5)
                        costRow(category: "餐饮", amount: 35000, percentage: 29.2)
                        costRow(category: "交通", amount: 15000, percentage: 12.5)
                        costRow(category: "景点", amount: 12000, percentage: 10.0)
                        costRow(category: "购物", amount: 13000, percentage: 10.8)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                
                // 时间分配
                VStack(alignment: .leading, spacing: 16) {
                    Text("时间分配")
                        .font(.headline)
                    
                    // 这里会放时间分配图表
                    timeDistributionView
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding()
        }
    }
    
    // MARK: - 统计视图组件
    
    // 统计卡片
    private func statCard(value: String, title: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    // 成本行
    private func costRow(category: String, amount: Double, percentage: Double) -> some View {
        HStack {
            Circle()
                .fill(categoryColor(category))
                .frame(width: 10, height: 10)
            
            Text(category)
                .font(.subheadline)
            
            Spacer()
            
            Text("¥\(Int(amount))")
                .font(.subheadline)
            
            Text("\(Int(percentage))%")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .trailing)
        }
    }
    
    // 时间分配视图
    private var timeDistributionView: some View {
        VStack(spacing: 12) {
            // 这里会放时间分布图表
            HStack(spacing: 0) {
                Rectangle().fill(Color.blue).frame(width: 60)
                Rectangle().fill(Color.green).frame(width: 120)
                Rectangle().fill(Color.orange).frame(width: 90)
                Rectangle().fill(Color.purple).frame(width: 40)
                Rectangle().fill(Color.red).frame(width: 50)
            }
            .frame(height: 20)
            .cornerRadius(5)
            
            // 时间分布项
            timeDistributionRow(category: "景点游览", hours: 12, color: .blue)
            timeDistributionRow(category: "用餐", hours: 6, color: .green)
            timeDistributionRow(category: "交通", hours: 4.5, color: .orange)
            timeDistributionRow(category: "休息", hours: 2, color: .purple)
            timeDistributionRow(category: "购物", hours: 2.5, color: .red)
        }
    }
    
    // 时间分配行
    private func timeDistributionRow(category: String, hours: Double, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            Text(category)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(Int(hours))小时\(hours.truncatingRemainder(dividingBy: 1) > 0 ? "30分" : "")")
                .font(.subheadline)
            
            Text("\(Int(hours / 27 * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .trailing)
        }
    }
    
    // MARK: - 辅助方法和计算属性
    
    private var optimizationPreferenceLabel: String {
        switch optimizationPreference {
        case .timeEfficient: return "时间优先"
        case .costEffective: return "成本优先"
        case .experienceOptimal: return "体验优先"
        case .balanced: return "平衡模式"
        }
    }
    
    private var optimizationPreferenceIcon: String {
        switch optimizationPreference {
        case .timeEfficient: return "clock"
        case .costEffective: return "dollarsign.circle"
        case .experienceOptimal: return "star"
        case .balanced: return "equal.circle"
        }
    }
    
    private func conflictTypeIcon(_ type: TravelConflict.ConflictType) -> String {
        switch type {
        case .timeOverlap: return "clock.badge.exclamationmark"
        case .distanceFeasibility: return "map.badge.exclamationmark"
        case .openingHours: return "building.2.badge.exclamationmark"
        case .budgetExceeded: return "dollarsign.circle.badge.exclamationmark"
        case .trafficDelay: return "exclamationmark.triangle.fill"
        }
    }
    
    private func showNewItinerarySheet() {
        // 实现新建行程功能
    }
    
    private func optimizeCurrentItinerary() {
        // 实现优化当前行程功能
        isLoadingData = true
        
        // 模拟优化过程
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoadingData = false
            
            // 创建模拟冲突
            conflicts = [
                TravelConflict(
                    type: .timeOverlap,
                    description: "浅草寺和东京塔的参观时间有冲突",
                    affectedLocations: [sampleLocations[0], sampleLocations[1]],
                    suggestedSolution: "建议提前1小时参观浅草寺"
                ),
                TravelConflict(
                    type: .trafficDelay,
                    description: "前往寿司大餐厅的路线可能会遇到交通拥堵",
                    affectedLocations: [sampleLocations[2]],
                    suggestedSolution: "建议改乘地铁或调整用餐时间"
                )
            ]
            
            showingConflicts = !conflicts.isEmpty
        }
    }
    
    private func showItinerarySettings() {
        // 实现行程设置功能
    }
    
    private func resolveConflictsAutomatically() {
        // 实现自动解决冲突功能
        isLoadingData = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoadingData = false
            conflicts = []
            showingConflicts = false
            
            // 更新解决冲突后的行程
        }
    }
    
    private func generateOptimalRoute() {
        // 开始加载指示器
        isLoadingData = true
        
        // 模拟AI优化过程，实际应用中这里会调用AI服务
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // 根据优化策略生成路线
            route = generateRouteBasedOnOptimization(sampleLocations)
            
            // 更新地图区域以显示所有位置
            updateMapRegionToShowAllLocations()
            
            // 检测可能的冲突
            detectConflicts()
            
            // 停止加载指示器
            isLoadingData = false
        }
    }
    
    private func generateRouteBasedOnOptimization(_ locations: [Location]) -> [Location] {
        // 这里只是一个简单模拟，实际应用中会根据选定的优化方法计算最佳路线
        switch optimizationMethod {
        case 0: // 最短路径
            // 简单模拟 - 对位置进行一些重新排序
            return locations.shuffled()
        case 1: // 最省时间
            // 按开放时间排序（简单模拟）
            return locations.sorted { $0.timeSpent < $1.timeSpent }
        default: // 平衡模式
            // 一些平衡考虑的排序
            return locations
        }
    }
    
    private func detectConflicts() {
        // 清除之前的冲突
        conflicts = []
        
        // 模拟检测到的冲突
        let timeConflict = TravelConflict(
            type: .timeOverlap,
            description: "浅草寺和上野公园的游览时间有重叠",
            affectedLocations: [sampleLocations[0], sampleLocations[1]],
            suggestedSolution: "建议将上野公园移至下午3点后，或调整游览时间"
        )
        
        let distanceConflict = TravelConflict(
            type: .distanceFeasibility,
            description: "从东京塔到富士山的距离太远，当天往返不现实",
            affectedLocations: [sampleLocations[2]],
            suggestedSolution: "建议调整行程，在富士山地区住宿一晚"
        )
        
        conflicts = [timeConflict, distanceConflict]
        
        // 如果检测到冲突，显示提醒
        if !conflicts.isEmpty {
            showingConflicts = true
        }
    }
    
    private func updateMapRegionToShowAllLocations() {
        guard !route.isEmpty else { return }
        
        var minLat = route[0].coordinate.latitude
        var maxLat = route[0].coordinate.latitude
        var minLon = route[0].coordinate.longitude
        var maxLon = route[0].coordinate.longitude
        
        for location in route {
            minLat = min(minLat, location.coordinate.latitude)
            maxLat = max(maxLat, location.coordinate.latitude)
            minLon = min(minLon, location.coordinate.longitude)
            maxLon = max(maxLon, location.coordinate.longitude)
        }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        withAnimation {
            region = MKCoordinateRegion(center: center, span: span)
        }
    }
    
    private func addNewLocation() {
        // 创建新的位置
        let newLocation = Location(
            id: UUID().uuidString,
            name: newLocationName,
            coordinate: CLLocationCoordinate2D(
                latitude: tapLocation?.latitude ?? 35.6812,
                longitude: tapLocation?.longitude ?? 139.7671
            ),
            type: newLocationType,
            timeSpent: newLocationTimeSpent,
            openingHours: "\(formatTime(newLocationOpenTime))-\(formatTime(newLocationCloseTime))",
            notes: newLocationNotes,
            address: newLocationAddress,
            cost: Double(newLocationCost) ?? 0.0,
            priority: newLocationPriority
        )
        
        // 如果正在创建路线，则添加到路线中
        if route.isEmpty {
            // 添加到样本位置列表中
            sampleLocations.append(newLocation)
        } else {
            // 添加到当前路线中
            route.append(newLocation)
        }
        
        // 重置表单字段
        resetNewLocationForm()
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func resetNewLocationForm() {
        newLocationName = ""
        newLocationType = .attraction
        newLocationTimeSpent = 60
        newLocationOpenTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        newLocationCloseTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()
        newLocationNotes = ""
        newLocationAddress = ""
        newLocationCost = ""
        newLocationPriority = false
    }
    
    private func iconForType(_ type: Location.LocationType) -> String {
        switch type {
        case .attraction: return "star.fill"
        case .restaurant: return "fork.knife"
        case .hotel: return "bed.double.fill"
        case .shopping: return "bag.fill"
        case .transport: return "airplane"
        case .activity: return "figure.hiking"
        default: return "mappin"
        }
    }
    
    private func colorForType(_ type: Location.LocationType) -> Color {
        switch type {
        case .attraction: return .blue
        case .restaurant: return .orange
        case .hotel: return .purple
        case .shopping: return .pink
        case .transport: return .green
        case .activity: return .red
        default: return .gray
        }
    }
    
    private func getEventsForHour(_ hour: Int, on date: Date) -> [TimelineEvent] {
        if hour == 9 {
            return [
                TimelineEvent(
                    name: "东京塔",
                    timeRange: "09:00-11:00",
                    details: "门票成人¥1000，可俯瞰东京美景",
                    icon: "building.2.fill",
                    color: .orange,
                    isTransport: false
                )
            ]
        } else if hour == 11 {
            return [
                TimelineEvent(
                    name: "前往浅草寺",
                    timeRange: "11:00-11:45",
                    details: "地铁銀座線至浅草站，约45分钟",
                    icon: "tram.fill",
                    color: .blue,
                    isTransport: true
                )
            ]
        } else if hour == 12 {
            return [
                TimelineEvent(
                    name: "浅草寺",
                    timeRange: "12:00-13:30",
                    details: "东京最古老的寺庙，可体验传统文化",
                    icon: "building.columns.fill",
                    color: .orange,
                    isTransport: false
                )
            ]
        } else if hour == 14 {
            return [
                TimelineEvent(
                    name: "前往寿司大",
                    timeRange: "14:00-14:30",
                    details: "出租车，约30分钟",
                    icon: "car.fill",
                    color: .orange,
                    isTransport: true
                ),
                TimelineEvent(
                    name: "寿司大用餐",
                    timeRange: "14:30-15:30",
                    details: "顶级寿司店，人均¥12000，需提前预约",
                    icon: "fork.knife",
                    color: .red,
                    isTransport: false
                )
            ]
        }
        return []
    }
    
    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "住宿": return .blue
        case "餐饮": return .green
        case "交通": return .orange
        case "景点": return .purple
        case "购物": return .red
        default: return .gray
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

// 时间线事件模型
struct TimelineEvent {
    let name: String
    let timeRange: String
    let details: String
    let icon: String
    let color: Color
    let isTransport: Bool
}

// 预览提供者
struct SmartTravelVisualizationSystem_Previews: PreviewProvider {
    static var previews: some View {
        SmartTravelVisualizationSystem()
    }
}

// 位置详情视图
struct LocationDetailView: View {
    let location: Location
    @State private var showingDirections = false
    @State private var showingShare = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 顶部图片和图标
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(height: 200)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 16) {
                            Image(systemName: iconForType(location.type))
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                                .background(colorForType(location.type))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(location.name)
                                    .font(.title)
                                    .bold()
                                
                                Text(location.type.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(radius: 3)
                        )
                        .offset(y: 30)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
                
                // 详情内容
                VStack(alignment: .leading, spacing: 20) {
                    // 基本信息部分
                    detailInfoSection
                    
                    // 访问时间与开放时间
                    timeInfoSection
                    
                    // 地址与位置
                    addressSection
                    
                    // 费用信息
                    costSection
                    
                    // 笔记
                    if !location.notes.isEmpty {
                        notesSection
                    }
                    
                    // 交通建议
                    transportRecommendationSection
                    
                    // 智能建议
                    aiRecommendationSection
                    
                    // 操作按钮
                    actionButtonsSection
                }
                .padding()
            }
        }
        .navigationBarItems(
            trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showingDirections) {
            // 在这里显示导航视图
            Text("导航到\(location.name)")
                .padding()
        }
        .actionSheet(isPresented: $showingShare) {
            ActionSheet(
                title: Text("分享\(location.name)"),
                message: Text("选择分享方式"),
                buttons: [
                    .default(Text("分享链接")) { /* 分享操作 */ },
                    .default(Text("分享为图片")) { /* 分享操作 */ },
                    .default(Text("添加到行程")) { /* 分享操作 */ },
                    .cancel()
                ]
            )
        }
    }
    
    // 基本信息部分
    private var detailInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("景点详情")
                    .font(.headline)
                
                Spacer()
                
                if location.priority {
                    Label("优先景点", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Divider()
            
            Text("建议游览时长：\(formatDuration(location.timeSpent))")
                .font(.subheadline)
            
            if let openingHours = location.openingHours {
                Text("营业时间：\(openingHours)")
                    .font(.subheadline)
            }
            
            // 可以添加其他信息，如评级、拥挤度等
            HStack {
                Image(systemName: "person.3.fill")
                Text("当前游客量: 较少")
                    .font(.caption)
            }
            .foregroundColor(.green)
            .padding(.top, 4)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // 访问时间与开放时间
    private var timeInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("时间安排")
                .font(.headline)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("计划到达")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("14:30")
                        .font(.title3)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("计划离开")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("16:00")
                        .font(.title3)
                }
            }
            
            // 开放时间指示器
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("营业状态")
                        .font(.caption)
                    
                    Spacer()
                    
                    Text("营业中")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
                // 营业时间条
                ZStack(alignment: .leading) {
                    // 背景条
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    // 营业时间
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 200, height: 8)
                        .cornerRadius(4)
                    
                    // 当前时间指示器
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 2, height: 16)
                        .offset(x: 120)
                }
                
                HStack {
                    Text("9:00")
                        .font(.caption)
                    
                    Spacer()
                    
                    Text("21:00")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // 地址与位置
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("地址信息")
                .font(.headline)
            
            Divider()
            
            Text(location.address)
                .font(.subheadline)
            
            // 小地图预览
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 100)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "map")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                )
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // 费用信息
    private var costSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("费用信息")
                .font(.headline)
            
            Divider()
            
            HStack {
                Text("门票")
                    .font(.subheadline)
                
                Spacer()
                
                Text("¥\(Int(location.cost))")
                    .font(.subheadline)
                    .bold()
            }
            
            HStack {
                Text("优惠政策")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // 笔记部分
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("我的笔记")
                .font(.headline)
            
            Divider()
            
            Text(location.notes)
                .font(.subheadline)
                .lineLimit(nil)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // 交通建议
    private var transportRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("交通建议")
                .font(.headline)
            
            Divider()
            
            ForEach(TravelMode.allModes.prefix(3)) { mode in
                HStack {
                    Image(systemName: mode.icon)
                        .foregroundColor(mode.color)
                        .frame(width: 30)
                    
                    VStack(alignment: .leading) {
                        Text(mode.name)
                            .font(.subheadline)
                        
                        Text("约\(Int(5 + Double(mode.id.hashValue % 20)))分钟，\(Int(100 + Double(mode.id.hashValue % 500)))米")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // 预估时间和费用
                    VStack(alignment: .trailing) {
                        if mode.costPerKm > 0 {
                            Text("¥\(Int(mode.costPerKm * 2))")
                                .font(.subheadline)
                        } else {
                            Text("免费")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
                
                if mode.id != TravelMode.allModes.prefix(3).last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // AI智能建议
    private var aiRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "wand.and.stars")
                    .foregroundColor(.purple)
                
                Text("AI智能建议")
                    .font(.headline)
                    .foregroundColor(.purple)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                recommendationRow(
                    icon: "clock.fill",
                    title: "最佳游览时间",
                    description: "建议下午2点-4点前往，游客较少"
                )
                
                recommendationRow(
                    icon: "mappin.and.ellipse",
                    title: "周边推荐",
                    description: "附近有3个热门景点，可一同游览"
                )
                
                recommendationRow(
                    icon: "figure.walk",
                    title: "行程建议",
                    description: "建议与东京塔安排在同一天游览"
                )
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(10)
    }
    
    // 推荐行
    private func recommendationRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.purple)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
    }
    
    // 辅助方法
    private func iconForType(_ type: Location.LocationType) -> String {
        switch type {
        case .attraction: return "star.fill"
        case .restaurant: return "fork.knife"
        case .hotel: return "bed.double.fill"
        case .shopping: return "bag.fill"
        case .transport: return "airplane"
        case .activity: return "figure.hiking"
        default: return "mappin"
        }
    }
    
    private func colorForType(_ type: Location.LocationType) -> Color {
        switch type {
        case .attraction: return .blue
        case .restaurant: return .orange
        case .hotel: return .purple
        case .shopping: return .pink
        case .transport: return .green
        case .activity: return .red
        default: return .gray
        }
    }
    
    // 操作按钮
    private var actionButtonsSection: some View {
        HStack(spacing: 20) {
            Button(action: {
                showingDirections = true
            }) {
                VStack {
                    Image(systemName: "location.fill")
                        .font(.system(size: 20))
                    
                    Text("导航")
                        .font(.caption)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                // 添加到收藏夹
            }) {
                VStack {
                    Image(systemName: "heart")
                        .font(.system(size: 20))
                    
                    Text("收藏")
                        .font(.caption)
                }
                .foregroundColor(.pink)
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                showingShare = true
            }) {
                VStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                    
                    Text("分享")
                        .font(.caption)
                }
                .foregroundColor(.green)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

private func formatDuration(_ minutes: Int) -> String {
    if minutes < 60 {
        return "\(minutes)分钟"
    } else {
        let hours = minutes / 60
        let mins = minutes % 60
        return mins > 0 ? "\(hours)小时\(mins)分钟" : "\(hours)小时"
    }
}

