//
//  CreateSetView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import SwiftUI

struct CreateSetView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: CreateSetViewModel
    
    var body: some View {
        VStack {
            Text("セットは短く簡潔に設定するのがおすすめです")
            
            VStack {
                CustomTextEditor(text: $viewModel.setText, placeHolder: "追加するセットを入力")
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, minHeight: 48)
                
                Color.gray
                    .frame(height: 1)
                
                HStack(alignment: .bottom) {
                    Spacer()
                    
                    Text("\(viewModel.setText.count)")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.chepicsPrimary))
                    
                    Text("/ \(Constants.setCount)")
                        .font(.caption)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                }
            }
            .padding()
            
            Spacer()
            
            Divider()
            
            RoundButton(text: "セットを追加", isActive: viewModel.isActive, type: .fill) {
                
            }
        }
        .navigationTitle("セットを追加")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                }

            }
        }
    }
}

#Preview {
    CreateSetView(viewModel: CreateSetViewModel(topicId: ""))
}
