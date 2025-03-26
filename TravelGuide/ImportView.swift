//
//  ImportView.swift
//  TravelGuide
//
//  Created by zhetao Wang on 2025/3/26.
//

import SwiftUI

struct ImportedItem: Identifiable {
    let id = UUID()
    let title: String
    let source: String
    let date: Date
    let imported: Bool
}

struct ImportView: View {
    @State private var urlString = ""
    @State private var isImporting = false
    @State private var showShareSheet = false
    @State private var showSuccessAlert = false
    @State private var importedItems = [
        ImportedItem(title: "东京银座最值得逛的店铺推荐", source: "小红书", date: Date().addingTimeInterval(-86400 * 2), imported: true),
        ImportedItem(title: "京都赏樱一日游路线", source: "小红书", date: Date().addingTimeInterval(-86400 * 5), imported: true)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 导入框
                VStack(spacing: 15) {
                    Text("从小红书导入旅游攻略")
                        .font(.headline)
                    
                    HStack {
                        TextField("粘贴小红书链接", text: $urlString)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        Button(action: {
                            importFromXiaohongshu()
                        }) {
                            Text("导入")
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(urlString.isEmpty)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        showShareSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("从小红书App分享")
                        }
                        .foregroundColor(.orange)
                    }
                    .padding(.top, 5)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding()
                
                // 导入记录
                VStack(alignment: .leading) {
                    Text("导入记录")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if importedItems.isEmpty {
                        VStack {
                            Spacer()
                            Text("暂无导入记录")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(height: 200)
                    } else {
                        List {
                            ForEach(importedItems) { item in
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(item.title)
                                            .font(.subheadline)
                                        
                                        HStack {
                                            Text("来源: \(item.source)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            
                                            Spacer()
                                            
                                            Text(formattedDate(item.date))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .opacity(item.imported ? 1.0 : 0.0)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .navigationTitle("导入攻略")
            .overlay(
                Group {
                    if isImporting {
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .overlay(
                                VStack {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                    Text("正在导入...")
                                        .padding(.top)
                                        .foregroundColor(.white)
                                }
                            )
                    }
                }
            )
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("导入成功"),
                    message: Text("已成功导入小红书内容"),
                    dismissButton: .default(Text("确定"))
                )
            }
        }
    }
    
    private func importFromXiaohongshu() {
        guard !urlString.isEmpty else { return }
        
        isImporting = true
        
        // 模拟网络请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newItem = ImportedItem(
                title: "北海道冬季旅游全攻略",
                source: "小红书",
                date: Date(),
                imported: true
            )
            
            importedItems.insert(newItem, at: 0)
            urlString = ""
            isImporting = false
            showSuccessAlert = true
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

#Preview {
    ImportView()
} 
