//
//  ImageView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/21.
//

import SwiftUI
import Kingfisher

struct ImageView: View {
    @EnvironmentObject var viewModel: MainTabViewModel
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: $viewModel.selectedImage) {
                ForEach(viewModel.images, id: \.self) { image in
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFit()
                        .tag(image)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.showImageViewer = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.34))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .padding(16)
        }
    }
}

#Preview {
    ImageView()
}
