//
//  MyPageTopicListView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/05.
//

import SwiftUI

struct MyPageTopicListView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(0 ..< 10, id: \.self) { _ in
                        myPageTopicCell
                    }
                }
            }
        }
        .navigationTitle("参加中のセット")
    }
    
    var myPageTopicCell: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("topic")
                    .font(.headline)
                    .foregroundStyle(.chepicsPrimary)
                
                Spacer()
                
                Image(.orangePeople)
                
                Text("300")
                    .font(.footnote)
                    .foregroundStyle(.chepicsPrimary)
            }
            
            Text("どの猫が一番好き？")
                .fontWeight(.semibold)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            HStack {
                Text("set")
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Text("30%")
                    .font(.footnote)
                    .foregroundStyle(.blue)
                    .padding(.trailing, 16)
                
                Image(.bluePeople)
                
                Text("90")
                    .font(.footnote)
                    .foregroundStyle(.blue)
            }
            
            Text("うちの猫だけが世界一可愛い")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.blue)
                }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(style: StrokeStyle())
                .foregroundStyle(.chepicsPrimary)
        }
        .padding()
    }
}

#Preview {
    MyPageTopicListView()
}
