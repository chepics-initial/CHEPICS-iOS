//
//  SplashView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/05.
//

import SwiftUI
import Lottie

struct SplashView: View {
    @State var viewModel: SplashViewModel
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .overlay {
                LottieView {
                    await LottieAnimation.loadedFrom(url: jsonURL!)
                }
                .playing(.fromProgress(0, toProgress: progress, loopMode: .playOnce))
                .animationDidFinish({ completed in
                    if progress != 0, completed {
                        viewModel.splashCompletion()
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .task {
                    try? await Task.sleep(for: .seconds(0.15))
                    progress = 1.0
                }
            }
            .ignoresSafeArea()
    }
    
    private var jsonURL: URL? {
        if let bundlePath = Bundle.main.path(forResource: "ChepicsSplash", ofType: "json") {
            return URL(filePath: bundlePath)
        }
        
        return nil
    }
}

#Preview {
    SplashView(viewModel: SplashViewModel(splashUseCase: SplashUseCase_Previews()))
}
