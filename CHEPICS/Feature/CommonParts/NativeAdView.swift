//
//  NativeAdView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/08/10.
//

import SwiftUI
import GoogleMobileAds

struct NativeAdView: UIViewRepresentable {
    var adUnitID: String
    
    class Coordinator: NSObject, GADNativeAdLoaderDelegate {
        var parent: NativeAdView
        var nativeAdView: GADNativeAdView?
        
        init(_ parent: NativeAdView) {
            self.parent = parent
        }
        
        func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
            guard let nativeAdView = nativeAdView else { return }
            
            // ネイティブ広告を受け取った後に表示要素を設定
            (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
            (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
            (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
            (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
            
            // その他の要素も同様に設定
            nativeAdView.nativeAd = nativeAd
            
            if let headline = nativeAd.headline {
                print("Headline: \(headline)")
                (nativeAdView.headlineView as? UILabel)?.text = headline
            }
            if let body = nativeAd.body {
                print("Body: \(body)")
                (nativeAdView.bodyView as? UILabel)?.text = body
            }
            if let callToAction = nativeAd.callToAction {
                print("Call to Action: \(callToAction)")
                (nativeAdView.callToActionView as? UIButton)?.setTitle(callToAction, for: .normal)
            }
            if let icon = nativeAd.icon?.image {
                print("Icon image received.")
                (nativeAdView.iconView as? UIImageView)?.image = icon
            }
        }
        
        func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
            print("Failed to load native ad: \(error.localizedDescription)")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        
        // 必要なUI要素をネイティブ広告ビューに追加します。
        let headlineView = UILabel()
        nativeAdView.headlineView = headlineView
        nativeAdView.addSubview(headlineView)
        
        let bodyView = UILabel()
        nativeAdView.bodyView = bodyView
        nativeAdView.addSubview(bodyView)
        
        let callToActionView = UIButton()
        nativeAdView.callToActionView = callToActionView
        nativeAdView.isUserInteractionEnabled = true
        nativeAdView.addSubview(callToActionView)
        
        let iconView = UIImageView()
        nativeAdView.iconView = iconView
        nativeAdView.addSubview(iconView)
        
        context.coordinator.nativeAdView = nativeAdView
        
        let adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: UIApplication.shared.getRootViewController(),
                                   adTypes: [.native], options: nil)
        adLoader.delegate = context.coordinator
        adLoader.load(GADRequest())
        
        return nativeAdView
    }
    
    func updateUIView(_ uiView: GADNativeAdView, context: Context) {
        // 必要に応じてビューの更新処理を行います。
    }
}
