//
//  ExploreResultView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/18.
//

import SwiftUI
import SwiftUIIntrospect

struct ExploreResultView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @StateObject var viewModel: ExploreTopViewModel
    
    var body: some View {
        VStack {
            SearchTextField(searchText: $viewModel.searchText, textField: {
                TextField("検索", text: $viewModel.searchText)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit {
                    }
                    .frame(maxWidth: .infinity)
                    .introspect(.textField, on: .iOS(.v16, .v17
                                                    )) { textField in
                        textField.enablesReturnKeyAutomatically = true
                    }
            }, onTapBackButton: {
                dismiss()
            }, onTapDeleteButton: {
                viewModel.onTapDeleteButton()
            })
        }
    }
}

//#Preview {
//    ExploreResultView()
//}
