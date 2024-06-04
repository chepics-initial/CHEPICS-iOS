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
    @FocusState private var isFocused: Bool
    let completion: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Text("セットは短く簡潔に設定するのがおすすめです")
                
                VStack {
                    CustomTextEditor(text: $viewModel.setText, placeHolder: "追加するセットを入力")
                        .focused($isFocused)
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
                    isFocused = false
                    Task {
                        await viewModel.onTapButton()
                        if viewModel.isCompleted {
                            completion()
                            dismiss()
                        }
                    }
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
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
        .networkError($viewModel.showAlert, closeAction: {
            isFocused = true
        })
    }
}

#Preview {
    CreateSetView(viewModel: CreateSetViewModel(topicId: "", createSetUseCase: CreateSetUseCase_Previews()), completion: {})
}
