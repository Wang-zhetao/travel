//
//  FoodView.swift
//  TravelGuide
//
//  Created on 2025/3/31.
//

import SwiftUI

struct FoodView: View {
    // 状态变量
    @State private var searchText = ""
    @State private var selectedCity = "北京"
    @State private var selectedCategory = 0
    @State private var showPreOrderSheet = false
    @State private var selectedRestaurant: Restaurant? = nil
    
    // 城市数据
    let cities = ["北京", "上海", "广州", "深圳", "杭州", "成都", "重庆", "西安"]
    
    // 分类数据
    let categories = ["推荐", "黑珍珠", "必吃榜", "社区老店", "咖啡甜品"]
    
    // 餐厅数据
    let restaurants = [
        // 黑珍珠餐厅
        Restaurant(
            name: "京兆尹", 
            category: "黑珍珠", 
            rating: 4.9, 
            price: "¥1200/人", 
            address: "北京市东城区东交民巷33号", 
            waitTime: "约90分钟", 
            image: "restaurant1",
            description: "黑珍珠三钻餐厅，提供精致的现代中式料理，以创新手法演绎传统京菜。",
            dishes: ["招牌烤鸭", "松茸鸡汤", "宫保虾球", "黄金蟹粉豆腐"],
            tags: ["中式", "创意菜", "商务宴请"]
        ),
        Restaurant(
            name: "富春小笼", 
            category: "必吃榜", 
            rating: 4.7, 
            price: "¥88/人", 
            address: "上海市黄浦区南京东路829号", 
            waitTime: "约45分钟", 
            image: "restaurant2",
            description: "大众点评必吃榜餐厅，以正宗的上海小笼包和本帮菜闻名，已有80年历史。",
            dishes: ["蟹粉小笼包", "红烧肉", "葱油拌面", "八宝饭"],
            tags: ["上海菜", "小吃", "老字号"]
        ),
        Restaurant(
            name: "成都吃客", 
            category: "必吃榜", 
            rating: 4.8, 
            price: "¥128/人", 
            address: "成都市锦江区红星路三段1号", 
            waitTime: "约60分钟", 
            image: "restaurant3",
            description: "大众点评必吃榜餐厅，创新川菜，麻辣鲜香，菜品精致美观。",
            dishes: ["吃客冷吃兔", "霸王花甲", "碳烤空心菜", "红糖糍粑"],
            tags: ["川菜", "创意菜", "聚餐"]
        ),
        
        // 社区老店
        Restaurant(
            name: "谭记肠粉", 
            category: "社区老店", 
            rating: 4.5, 
            price: "¥15/人", 
            address: "广州市越秀区文明路121号", 
            waitTime: "约15分钟", 
            image: "restaurant4",
            description: "广州老字号早餐店，以现做肠粉和靓汤著称，当地人从小吃到大的味道。",
            dishes: ["鲜虾肠粉", "牛肉肠粉", "猪杂粥", "油条"],
            tags: ["粤式早茶", "小吃", "传统"]
        ),
        Restaurant(
            name: "老张牛肉面", 
            category: "社区老店", 
            rating: 4.6, 
            price: "¥22/人", 
            address: "西安市碑林区东关正街18号", 
            waitTime: "约20分钟", 
            image: "restaurant5",
            description: "西安本地人最爱的牛肉面馆，面条劲道，汤头浓郁，已经营业30余年。",
            dishes: ["牛肉拉面", "羊肉泡馍", "凉皮", "肉夹馍"],
            tags: ["陕西菜", "面食", "家常"]
        ),
        
        // 咖啡甜品
        Restaurant(
            name: "喜茶", 
            category: "咖啡甜品", 
            rating: 4.3, 
            price: "¥35/人", 
            address: "深圳市南山区海岸城购物中心L1层", 
            waitTime: "约25分钟", 
            image: "restaurant6",
            description: "知名新式茶饮品牌，提供多种创意茶饮和甜品，支持线上预点。",
            dishes: ["芝芝芒芒", "多肉葡萄", "芝芝莓莓", "波波冰"],
            tags: ["茶饮", "甜品", "支持预点"],
            supportsPreOrder: true
        ),
        Restaurant(
            name: "瑞幸咖啡", 
            category: "咖啡甜品", 
            rating: 4.2, 
            price: "¥28/人", 
            address: "杭州市西湖区文三路478号", 
            waitTime: "约5分钟", 
            image: "restaurant7",
            description: "连锁咖啡品牌，提供多种咖啡饮品和轻食，支持线上预点和自取。",
            dishes: ["生椰拿铁", "瑞纳冰", "厚乳拿铁", "椰云拿铁"],
            tags: ["咖啡", "轻食", "支持预点"],
            supportsPreOrder: true
        )
    ]
    
    // 预点餐品牌
    let preOrderBrands = ["喜茶", "瑞幸咖啡", "奈雪的茶", "星巴克", "CoCo都可"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 顶部搜索栏和城市选择
                HStack {
                    // 城市选择
                    Picker("选择城市", selection: $selectedCity) {
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100)
                    
                    // 搜索栏
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("搜索餐厅、菜品", text: $searchText)
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
                    .padding(8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // 分类选择
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Button(action: {
                                selectedCategory = index
                            }) {
                                Text(categories[index])
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedCategory == index ? Color.orange : Color(UIColor.systemGray6))
                                    .foregroundColor(selectedCategory == index ? .white : .black)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // 预点餐快捷入口
                preOrderSection
                
                // 餐厅列表
                restaurantListSection
            }
            .padding(.vertical)
        }
        .navigationTitle("美食")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showPreOrderSheet) {
            preOrderSheetView
        }
        .sheet(item: $selectedRestaurant) { restaurant in
            restaurantDetailView(restaurant: restaurant)
        }
    }
    
    // 预点餐部分
    private var preOrderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("预点餐")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(preOrderBrands, id: \.self) { brand in
                        Button(action: {
                            showPreOrderSheet = true
                        }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(Color(UIColor.systemGray6))
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: getBrandIcon(for: brand))
                                        .font(.system(size: 24))
                                        .foregroundColor(.orange)
                                }
                                
                                Text(brand)
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }
    
    // 餐厅列表部分
    private var restaurantListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if selectedCategory == 0 {
                // 推荐部分标题
                HStack {
                    Text("为您推荐")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        // 查看更多
                    }) {
                        Text("更多")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
            }
            
            // 筛选后的餐厅列表
            LazyVStack(spacing: 16) {
                ForEach(filteredRestaurants) { restaurant in
                    restaurantCard(restaurant: restaurant)
                        .onTapGesture {
                            selectedRestaurant = restaurant
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // 餐厅卡片
    private func restaurantCard(restaurant: Restaurant) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // 餐厅图片和标签
            ZStack(alignment: .bottomLeading) {
                // 图片
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(height: 180)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
                
                // 分类标签
                HStack(spacing: 8) {
                    Text(restaurant.category)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(categoryColor(for: restaurant.category))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    
                    if restaurant.supportsPreOrder {
                        Text("支持预点")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                .padding(12)
            }
            
            // 餐厅信息
            VStack(alignment: .leading, spacing: 8) {
                // 名称和评分
                HStack {
                    Text(restaurant.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
                
                // 人均价格和等待时间
                HStack {
                    Text(restaurant.price)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(restaurant.waitTime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // 地址
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(restaurant.address)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                // 标签
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(restaurant.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // 预点餐表单视图
    private var preOrderSheetView: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 品牌选择
                Picker("选择品牌", selection: .constant("喜茶")) {
                    ForEach(preOrderBrands, id: \.self) { brand in
                        Text(brand).tag(brand)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // 门店选择
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.orange)
                    
                    Text("深圳市南山区海岸城购物中心L1层")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button(action: {
                        // 更换门店
                    }) {
                        Text("更换")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                // 菜单列表
                List {
                    Section(header: Text("人气推荐")) {
                        menuItem(name: "芝芝芒芒", price: "¥32", image: "drink1")
                        menuItem(name: "多肉葡萄", price: "¥29", image: "drink2")
                        menuItem(name: "芝芝莓莓", price: "¥32", image: "drink3")
                    }
                    
                    Section(header: Text("经典系列")) {
                        menuItem(name: "满杯红柚", price: "¥27", image: "drink4")
                        menuItem(name: "多肉芒芒甘露", price: "¥29", image: "drink5")
                        menuItem(name: "波波冰", price: "¥25", image: "drink6")
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                // 底部按钮
                Button(action: {
                    showPreOrderSheet = false
                }) {
                    Text("确认预点 (2件商品)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.top)
            .navigationTitle("预点餐")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("关闭") {
                showPreOrderSheet = false
            })
        }
    }
    
    // 餐厅详情视图
    private func restaurantDetailView(restaurant: Restaurant) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 餐厅图片
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
                
                // 餐厅信息
                VStack(alignment: .leading, spacing: 16) {
                    // 名称和评分
                    HStack {
                        Text(restaurant.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            
                            Text(String(format: "%.1f", restaurant.rating))
                                .font(.headline)
                        }
                    }
                    
                    // 分类标签
                    HStack(spacing: 8) {
                        Text(restaurant.category)
                            .font(.subheadline)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background(categoryColor(for: restaurant.category))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        
                        ForEach(restaurant.tags.prefix(2), id: \.self) { tag in
                            Text(tag)
                                .font(.subheadline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(4)
                        }
                    }
                    
                    // 价格和等待时间
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("人均")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(restaurant.price)
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("排队时间")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(restaurant.waitTime)
                                .font(.headline)
                        }
                    }
                    
                    Divider()
                    
                    // 餐厅描述
                    Text("餐厅简介")
                        .font(.headline)
                    
                    Text(restaurant.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    
                    Divider()
                    
                    // 招牌菜品
                    Text("招牌菜品")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(restaurant.dishes, id: \.self) { dish in
                                VStack(alignment: .leading, spacing: 8) {
                                    // 菜品图片
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray5))
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(8)
                                        .overlay(
                                            Image(systemName: "fork.knife")
                                                .font(.title)
                                                .foregroundColor(.gray)
                                        )
                                    
                                    // 菜品名称
                                    Text(dish)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                }
                                .frame(width: 120)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // 地址和导航
                    Text("位置和导航")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(restaurant.address)
                                .font(.subheadline)
                            
                            Text("距离您约3.5公里")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 导航
                        }) {
                            Text("导航")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color.blue)
                                .cornerRadius(6)
                        }
                    }
                    
                    // 地图预览
                    Rectangle()
                        .fill(Color(UIColor.systemGray6))
                        .frame(height: 180)
                        .cornerRadius(12)
                        .overlay(
                            Image(systemName: "map")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                }
                .padding()
                
                // 底部操作按钮
                HStack(spacing: 16) {
                    Button(action: {
                        // 收藏
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "heart")
                                .font(.title3)
                            
                            Text("收藏")
                                .font(.caption)
                        }
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    }
                    
                    Button(action: {
                        // 分享
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                            
                            Text("分享")
                                .font(.caption)
                        }
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    }
                    
                    Button(action: {
                        // 预约
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.title3)
                            
                            Text("预约")
                                .font(.caption)
                        }
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    }
                    
                    if restaurant.supportsPreOrder {
                        Button(action: {
                            showPreOrderSheet = true
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.title3)
                                
                                Text("预点")
                                    .font(.caption)
                            }
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6).opacity(0.5))
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // 菜单项
    private func menuItem(name: String, price: String, image: String) -> some View {
        HStack(spacing: 12) {
            // 饮品图片
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                )
            
            // 饮品信息
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                
                Text(price)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 添加按钮
            Button(action: {
                // 添加到购物车
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 4)
    }
    
    // 根据分类筛选餐厅
    var filteredRestaurants: [Restaurant] {
        if selectedCategory == 0 {
            // 推荐分类显示所有餐厅
            return restaurants.filter { restaurant in
                if searchText.isEmpty {
                    return true
                } else {
                    return restaurant.name.contains(searchText) ||
                           restaurant.tags.contains { $0.contains(searchText) } ||
                           restaurant.dishes.contains { $0.contains(searchText) }
                }
            }
        } else {
            // 其他分类只显示对应分类的餐厅
            let categoryName = categories[selectedCategory]
            return restaurants.filter { restaurant in
                let categoryMatch = restaurant.category == categoryName
                if searchText.isEmpty {
                    return categoryMatch
                } else {
                    return categoryMatch && (
                        restaurant.name.contains(searchText) ||
                        restaurant.tags.contains { $0.contains(searchText) } ||
                        restaurant.dishes.contains { $0.contains(searchText) }
                    )
                }
            }
        }
    }
    
    // 获取品牌图标
    private func getBrandIcon(for brand: String) -> String {
        switch brand {
        case "喜茶":
            return "cup.and.saucer.fill"
        case "瑞幸咖啡":
            return "mug.fill"
        case "奈雪的茶":
            return "leaf.fill"
        case "星巴克":
            return "star.fill"
        case "CoCo都可":
            return "drop.fill"
        default:
            return "cup.and.saucer"
        }
    }
    
    // 获取分类颜色
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "黑珍珠":
            return Color.purple
        case "必吃榜":
            return Color.orange
        case "社区老店":
            return Color.blue
        case "咖啡甜品":
            return Color.green
        default:
            return Color.gray
        }
    }
}

// 餐厅数据模型
struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let rating: Double
    let price: String
    let address: String
    let waitTime: String
    let image: String
    let description: String
    let dishes: [String]
    let tags: [String]
    var supportsPreOrder: Bool = false
}

#Preview {
    NavigationView {
        FoodView()
    }
}
