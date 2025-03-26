//
//  RouteMapView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: LocationType
    let timeSpent: TimeInterval // 预计停留时间（秒）
    let openingHours: String
    
    enum LocationType {
        case attraction
        case restaurant
        case hotel
        case transport
    }
}

struct RouteMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503), // 东京
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var selectedLocation: Location?
    @State private var showingLocationDetails = false
    @State private var route: [Location] = []
    @State private var mapType: MKMapType = .standard
    @State private var showingAddLocationSheet = false
    @State private var newLocationName = ""
    @State private var newLocationType: Location.LocationType = .attraction
    @State private var newLocationTime: Double = 1
    @State private var tapLocation: CLLocationCoordinate2D?
    
    // 示例行程数据
    let sampleLocations = [
        Location(name: "东京塔", 
                coordinate: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
                type: .attraction,
                timeSpent: 7200, // 2小时
                openingHours: "9:00-23:00"),
        Location(name: "浅草寺",
                coordinate: CLLocationCoordinate2D(latitude: 35.7147, longitude: 139.7966),
                type: .attraction,
                timeSpent: 5400, // 1.5小时
                openingHours: "6:00-17:00"),
        Location(name: "寿司大", 
                coordinate: CLLocationCoordinate2D(latitude: 35.6954, longitude: 139.7019),
                type: .restaurant,
                timeSpent: 3600, // 1小时
                openingHours: "11:00-22:00")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, 
                    interactionModes: .all,
                    showsUserLocation: false,
                    userTrackingMode: nil,
                    annotationItems: route.isEmpty ? sampleLocations : route) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 40, height: 40)
                                    .shadow(radius: 2)
                                
                                Image(systemName: iconForType(location.type))
                                    .font(.system(size: 20))
                                    .foregroundColor(colorForType(location.type))
                            }
                            
                            Text(location.name)
                                .font(.caption)
                                .padding(4)
                                .background(.white.opacity(0.8))
                                .cornerRadius(4)
                        }
                        .onTapGesture {
                            selectedLocation = location
                            showingLocationDetails = true
                        }
                    }
                }
                .mapStyle(.standard)
                .onLongPressGesture { location in
                    // 将长按位置转换为地理坐标
                    let mapSize = UIScreen.main.bounds.size
                    let point = CGPoint(x: location.x, y: location.y)
                    
                    // 简单的方法获取大致位置
                    let currentRegion = region
                    let centerPoint = CGPoint(x: mapSize.width / 2, y: mapSize.height / 2)
                    
                    let latitudeDistance = (point.y - centerPoint.y) / mapSize.height * currentRegion.span.latitudeDelta
                    let longitudeDistance = (point.x - centerPoint.x) / mapSize.width * currentRegion.span.longitudeDelta
                    
                    let latitude = currentRegion.center.latitude - latitudeDistance
                    let longitude = currentRegion.center.longitude + longitudeDistance
                    
                    tapLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    showingAddLocationSheet = true
                }
                
                // 如果有路线，绘制连接线
                if !route.isEmpty {
                    // 绘制路线连接线
                    RouteLineView(locations: route)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
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
                        }
                        .padding(.trailing)
                        .padding(.top)
                    }
                    
                    Spacer()
                    
                    if route.isEmpty {
                        Button(action: generateOptimalRoute) {
                            Text("生成最优路线")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                        .padding(.bottom)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(route) { location in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: iconForType(location.type))
                                                .foregroundColor(colorForType(location.type))
                                            Text(location.name)
                                                .font(.subheadline)
                                        }
                                        Text(formatDuration(location.timeSpent))
                                            .font(.caption)
                                            .foregroundColor(.gray)
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
                }
            }
            .navigationTitle("行程路线")
            .navigationBarItems(trailing: Button(action: resetRoute) {
                Image(systemName: "arrow.clockwise")
            })
            .sheet(isPresented: $showingLocationDetails) {
                if let location = selectedLocation {
                    LocationDetailView(location: location)
                }
            }
            .sheet(isPresented: $showingAddLocationSheet) {
                addLocationView
            }
        }
    }
    
    private var addLocationView: some View {
        NavigationView {
            Form {
                Section(header: Text("地点信息")) {
                    TextField("地点名称", text: $newLocationName)
                    
                    Picker("地点类型", selection: $newLocationType) {
                        Text("景点").tag(Location.LocationType.attraction)
                        Text("餐厅").tag(Location.LocationType.restaurant)
                        Text("住宿").tag(Location.LocationType.hotel)
                        Text("交通").tag(Location.LocationType.transport)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Stepper("停留时间: \(Int(newLocationTime)) 小时", value: $newLocationTime, in: 0.5...8, step: 0.5)
                }
                
                Section {
                    Button("添加到行程") {
                        addNewLocation()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(newLocationName.isEmpty ? Color.gray : Color.orange)
                    .cornerRadius(8)
                    .disabled(newLocationName.isEmpty)
                }
            }
            .navigationTitle("添加地点")
            .navigationBarItems(trailing: Button("取消") {
                showingAddLocationSheet = false
            })
        }
    }
    
    private func addNewLocation() {
        guard let coordinate = tapLocation, !newLocationName.isEmpty else { return }
        
        let newLocation = Location(
            name: newLocationName,
            coordinate: coordinate,
            type: newLocationType,
            timeSpent: newLocationTime * 3600, // 转换为秒
            openingHours: "9:00-20:00"
        )
        
        // 如果之前没有路线，就创建一个新路线
        if route.isEmpty {
            route = [newLocation]
        } else {
            // 否则添加到现有路线
            route.append(newLocation)
        }
        
        // 重置表单
        newLocationName = ""
        newLocationType = .attraction
        newLocationTime = 1
        showingAddLocationSheet = false
    }
    
    private func iconForType(_ type: Location.LocationType) -> String {
        switch type {
        case .attraction: return "star.fill"
        case .restaurant: return "fork.knife"
        case .hotel: return "bed.double.fill"
        case .transport: return "bus.fill"
        }
    }
    
    private func colorForType(_ type: Location.LocationType) -> Color {
        switch type {
        case .attraction: return .orange
        case .restaurant: return .red
        case .hotel: return .blue
        case .transport: return .green
        }
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        return "\(hours)小时\(minutes)分钟"
    }
    
    private func generateOptimalRoute() {
        // 这里可以实现实际的路线优化算法
        // 目前使用简单的示例
        withAnimation {
            route = sampleLocations.sorted { $0.coordinate.latitude < $1.coordinate.latitude }
            
            // 更新地图区域以显示所有位置
            if let minLat = route.map({ $0.coordinate.latitude }).min(),
               let maxLat = route.map({ $0.coordinate.latitude }).max(),
               let minLon = route.map({ $0.coordinate.longitude }).min(),
               let maxLon = route.map({ $0.coordinate.longitude }).max() {
                
                let center = CLLocationCoordinate2D(
                    latitude: (minLat + maxLat) / 2,
                    longitude: (minLon + maxLon) / 2
                )
                
                let span = MKCoordinateSpan(
                    latitudeDelta: (maxLat - minLat) * 1.5,
                    longitudeDelta: (maxLon - minLon) * 1.5
                )
                
                region = MKCoordinateRegion(center: center, span: span)
            }
        }
    }
    
    private func resetRoute() {
        withAnimation {
            route = []
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
    }
}

struct RouteLineView: View {
    let locations: [Location]
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                guard let firstLocation = locations.first else { return }
                
                // 将第一个点转换为屏幕坐标
                let firstPoint = convertCoordinateToPoint(firstLocation.coordinate, in: geo.size)
                path.move(to: firstPoint)
                
                // 连接其余点
                for location in locations.dropFirst() {
                    let point = convertCoordinateToPoint(location.coordinate, in: geo.size)
                    path.addLine(to: point)
                }
            }
            .stroke(Color.orange, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [5, 5]))
        }
    }
    
    private func convertCoordinateToPoint(_ coordinate: CLLocationCoordinate2D, in size: CGSize) -> CGPoint {
        // 这只是一个简单的转换，实际应用中需要更复杂的方法
        // 在这个简化示例中，我们假设经纬度可以线性映射到屏幕坐标
        
        let minLat = locations.map { $0.coordinate.latitude }.min() ?? 0
        let maxLat = locations.map { $0.coordinate.latitude }.max() ?? 0
        let minLon = locations.map { $0.coordinate.longitude }.min() ?? 0
        let maxLon = locations.map { $0.coordinate.longitude }.max() ?? 0
        
        let latRange = maxLat - minLat
        let lonRange = maxLon - minLon
        
        let normalizedLat = (coordinate.latitude - minLat) / latRange
        let normalizedLon = (coordinate.longitude - minLon) / lonRange
        
        return CGPoint(
            x: size.width * normalizedLon,
            y: size.height * (1 - normalizedLat) // 反转y轴，因为地图的北方在上方
        )
    }
}

struct LocationDetailView: View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(location.name)
                .font(.title)
                .bold()
            
            HStack {
                Image(systemName: iconForType(location.type))
                    .foregroundColor(colorForType(location.type))
                Text(typeString(location.type))
                    .foregroundColor(.gray)
            }
            
            HStack {
                Image(systemName: "clock")
                Text("建议游玩时长：\(formatDuration(location.timeSpent))")
            }
            
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                Text("营业时间：\(location.openingHours)")
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func iconForType(_ type: Location.LocationType) -> String {
        switch type {
        case .attraction: return "star.fill"
        case .restaurant: return "fork.knife"
        case .hotel: return "bed.double.fill"
        case .transport: return "bus.fill"
        }
    }
    
    private func colorForType(_ type: Location.LocationType) -> Color {
        switch type {
        case .attraction: return .orange
        case .restaurant: return .red
        case .hotel: return .blue
        case .transport: return .green
        }
    }
    
    private func typeString(_ type: Location.LocationType) -> String {
        switch type {
        case .attraction: return "景点"
        case .restaurant: return "餐厅"
        case .hotel: return "住宿"
        case .transport: return "交通"
        }
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        return "\(hours)小时\(minutes)分钟"
    }
}

#Preview {
    RouteMapView()
} 
