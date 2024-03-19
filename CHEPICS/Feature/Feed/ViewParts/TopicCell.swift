//
//  TopicCell.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import SwiftUI

struct TopicCell: View {
    @Environment(\.colorScheme) var colorScheme
    let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("参加中")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal)
                            .background {
                                Capsule(style: .circular)
                                    .foregroundStyle(.blue)
                            }
                        
                        Text("猫が可愛い")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        
                        Text("https://nekoneko.com")
                            .font(.caption)
                            .tint(.blue)
                            .padding(.vertical, 8)
                    }
                    
                    Spacer()
                }
                
                if let screenSize = window?.screen.bounds {
                    Image(.cat)
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenSize.width - 32, height: (screenSize.width - 32) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 0) {
                        Image(.chart)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                        
                        Text("10,000")
                            .font(.footnote)
                            .foregroundStyle(Color(.chepicsPrimary))
                    }
                    
                    Image(.catIcon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24)
                        .clipShape(Circle())
                    
                    Text("太郎")
                        .font(.caption)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    Spacer()
                    
                    Text("1時間前")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 16)
            
            Divider()
        }
    }
}

#Preview {
    TopicCell()
}
