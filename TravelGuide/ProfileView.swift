//
//  ProfileView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI

struct ProfileView: View {
    @State private var isLoggedIn = true
    @State private var username = "旅行爱好者"
    @State private var avatarImage = "person.circle.fill"
    
    var body: some View {
        NavigationView {
            List {
                if isLoggedIn {
                    // 用户信息
                    HStack(spacing: 15) {
                        Image(systemName: avatarImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(username)
                                .font(.title3)
                                .bold()
                            
                            Text("旅行攻略: 23 | 收藏: 156")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    
                    // 我的攻略
                    Section(header: Text("我的攻略")) {
                        NavigationLink(destination: Text("我创建的攻略")) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.orange)
                                Text("我创建的攻略")
                            }
                        }
                        
                        NavigationLink(destination: Text("我的收藏")) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                Text("我的收藏")
                            }
                        }
                        
                        NavigationLink(destination: Text("我的小红书导入")) {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .foregroundColor(.pink)
                                Text("小红书导入")
                            }
                        }
                    }
                    
                    // 旅行历史
                    Section(header: Text("旅行历史")) {
                        NavigationLink(destination: Text("已去过的地方")) {
                            HStack {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.green)
                                Text("已去过的地方")
                            }
                        }
                        
                        NavigationLink(destination: Text("计划去的地方")) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.blue)
                                Text("计划去的地方")
                            }
                        }
                    }
                } else {
                    // 未登录状态
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("登录以使用更多功能")
                            .font(.headline)
                        
                        Button(action: {
                            isLoggedIn = true
                        }) {
                            Text("登录/注册")
                                .frame(minWidth: 200)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                
                // 通用设置
                Section(header: Text("通用设置")) {
                    NavigationLink(destination: Text("通知设置")) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.purple)
                            Text("通知设置")
                        }
                    }
                    
                    NavigationLink(destination: Text("隐私设置")) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.blue)
                            Text("隐私设置")
                        }
                    }
                    
                    NavigationLink(destination: Text("关于我们")) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.gray)
                            Text("关于我们")
                        }
                    }
                }
                
                if isLoggedIn {
                    // 退出登录
                    Button(action: {
                        isLoggedIn = false
                    }) {
                        HStack {
                            Spacer()
                            Text("退出登录")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .padding()
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("个人中心")
        }
    }
}

#Preview {
    ProfileView()
} 
