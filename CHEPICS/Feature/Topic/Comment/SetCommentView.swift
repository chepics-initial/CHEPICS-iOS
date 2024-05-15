//
//  SetCommentView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import SwiftUI

struct SetCommentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var dismissView: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "text.bubble.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    
                    Text("コメント100件")
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                Text("うちの猫だけが世界一可愛い")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Text("20%")
                        .font(.footnote)
                    
                    HStack(spacing: 4) {
                        Image(.blackPeople)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("40")
                            .font(.footnote)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(0..<5, id: \.self) { _ in
                        NavigationLink {
                            SetCommentDetailView(dismissView: $dismissView)
                        } label: {
                            CommentCell(comment: mockComment1, type: .set, onTapImage: { index in
                            }, onTapUserInfo: { _ in
                                
                            })
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismissView = true
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

#Preview {
    SetCommentView(dismissView: .constant(false))
}
