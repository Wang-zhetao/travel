//
//  RouteMapView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI
import MapKit

// 提供地图和路线组合显示，用于SmartTravelVisualizationSystem
struct RouteMapView: View {
    var region: MKCoordinateRegion
    var locations: [Location]
    var travelMode: TravelMode
    var tapAction: ((CLLocationCoordinate2D) -> Void)?
    var annotationTapAction: ((Location) -> Void)?
    var mapType: MKMapType = .standard
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(region), 
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: nil,
                annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 40, height: 40)
                                .shadow(radius: 2)
                            
                            if let iconProvider = iconForType, let colorProvider = colorForType {
                                Image(systemName: iconProvider(location.type))
                                    .font(.system(size: 20))
                                    .foregroundColor(colorProvider(location.type))
                            } else {
                                Image(systemName: "mappin")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Text(location.name)
                            .font(.caption)
                            .padding(4)
                            .background(.white.opacity(0.8))
                            .cornerRadius(4)
                    }
                    .onTapGesture {
                        annotationTapAction?(location)
                    }
                }
            }
            .mapStyle(mapType == .standard ? .standard : .hybrid)
            .onTapGesture { _ in
                tapAction?(region.center)
            }
            
            // 如果有路线，绘制连接线
            if locations.count > 1 {
                RouteLineView(locations: locations, travelMode: travelMode)
            }
        }
    }
    
    // 可选的类型图标和颜色提供函数
    var iconForType: ((Any) -> String)?
    var colorForType: ((Any) -> Color)?
}

// 路线绘制视图，用于RouteMapView
struct RouteLineView: View {
    var locations: [Location]
    var travelMode: TravelMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 绘制路线线条
                Path { path in
                    guard locations.count > 1 else { return }
                    
                    // 创建路线路径
                    let firstLocation = locations[0]
                    let firstPoint = self.point(for: firstLocation.coordinate, in: geometry)
                    path.move(to: firstPoint)
                    
                    for i in 1..<locations.count {
                        let nextLocation = locations[i]
                        let nextPoint = self.point(for: nextLocation.coordinate, in: geometry)
                        path.addLine(to: nextPoint)
                    }
                }
                .stroke(travelMode.color, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [5, 5]))
                
                // 路线点
                ForEach(0..<locations.count) { i in
                    Circle()
                        .fill(travelMode.color)
                        .frame(width: 10, height: 10)
                        .position(self.point(for: locations[i].coordinate, in: geometry))
                }
                
                // 添加路线中间的交通模式图标
                if locations.count > 1 {
                    ForEach(0..<locations.count-1, id: \.self) { index in
                        let startPoint = point(for: locations[index].coordinate, in: geometry)
                        let endPoint = point(for: locations[index+1].coordinate, in: geometry)
                        let midPoint = CGPoint(
                            x: (startPoint.x + endPoint.x) / 2,
                            y: (startPoint.y + endPoint.y) / 2
                        )
                        
                        Image(systemName: travelMode.icon)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Circle().fill(travelMode.color))
                            .position(midPoint)
                    }
                }
            }
        }
    }
    
    // 将地理坐标转换为视图坐标
    private func point(for coordinate: CLLocationCoordinate2D, in geometry: GeometryProxy) -> CGPoint {
        guard locations.count > 1 else { return .zero }
        
        // 找出最大最小经纬度范围
        var minLat = locations[0].coordinate.latitude
        var maxLat = locations[0].coordinate.latitude
        var minLon = locations[0].coordinate.longitude
        var maxLon = locations[0].coordinate.longitude
        
        for location in locations {
            minLat = min(minLat, location.coordinate.latitude)
            maxLat = max(maxLat, location.coordinate.latitude)
            minLon = min(minLon, location.coordinate.longitude)
            maxLon = max(maxLon, location.coordinate.longitude)
        }
        
        // 添加一点边距
        let latPadding = (maxLat - minLat) * 0.1
        let lonPadding = (maxLon - minLon) * 0.1
        
        minLat -= latPadding
        maxLat += latPadding
        minLon -= lonPadding
        maxLon += lonPadding
        
        // 计算相对位置
        let relativeX = (coordinate.longitude - minLon) / (maxLon - minLon)
        let relativeY = (coordinate.latitude - minLat) / (maxLat - minLat)
        
        // 转换为视图坐标（注意y轴是反的）
        return CGPoint(
            x: geometry.size.width * CGFloat(relativeX),
            y: geometry.size.height * (1 - CGFloat(relativeY))
        )
    }
}

// 简单的地图视图，专为ExploreView设计
struct ExploreRouteMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503), // 东京
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // 示例位置标记
    private let sampleLocations = [
        SampleLocation(
            name: "东京塔",
            coordinate: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
            type: .attraction
        ),
        SampleLocation(
            name: "浅草寺",
            coordinate: CLLocationCoordinate2D(latitude: 35.7147, longitude: 139.7966),
            type: .attraction
        ),
        SampleLocation(
            name: "寿司大",
            coordinate: CLLocationCoordinate2D(latitude: 35.6954, longitude: 139.7019),
            type: .restaurant
        )
    ]
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: sampleLocations) { location in
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
                        // 点击标记的动作
                    }
                }
            }
            .overlay(
                VStack {
                    Spacer()
                    
                    // 底部信息面板
                    VStack(spacing: 12) {
                        Text("探索旅行路线")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        Text("开始规划您的完美旅程")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            // 在此处添加开始规划的动作
                        }) {
                            Text("开始规划")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding()
                }
            )
        }
        .navigationTitle("行程规划")
    }
    
    // 根据类型返回图标
    private func iconForType(_ type: SampleLocationType) -> String {
        switch type {
        case .attraction: return "star.fill"
        case .restaurant: return "fork.knife"
        case .hotel: return "bed.double.fill"
        case .shopping: return "bag.fill"
        case .transport: return "airplane"
        case .activity: return "figure.hiking"
        case .other: return "mappin"
        }
    }
    
    // 根据类型返回颜色
    private func colorForType(_ type: SampleLocationType) -> Color {
        switch type {
        case .attraction: return .blue
        case .restaurant: return .orange
        case .hotel: return .purple
        case .shopping: return .pink
        case .transport: return .green
        case .activity: return .red
        case .other: return .gray
        }
    }
}

// 用于ExploreRouteMapView的简化位置模型
struct SampleLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: SampleLocationType
}

// 简化的位置类型枚举
enum SampleLocationType {
    case attraction
    case restaurant
    case hotel
    case shopping
    case transport
    case activity
    case other
}

#Preview {
    ExploreRouteMapView()
} 
