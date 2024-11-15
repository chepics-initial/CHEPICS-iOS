//
//  UserIconView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/25.
//

import SwiftUI
import Kingfisher

enum IconScale {
    case topic
    case comment
    case user
    case profile
    
    var scaleValue: CGFloat {
        switch self {
        case .topic:
            24
        case .comment:
            32
        case .user:
            40
        case .profile:
            64
        }
    }
}

struct UserIconView: View {
    let url: String?
    let scale: IconScale
    
    var body: some View {
        if let url {
            KFImage(URL(string: url))
                .resizable()
                .scaledToFill()
                .frame(width: scale.scaleValue, height: scale.scaleValue)
                .clipShape(Circle())
                .background {
                    Circle()
                        .foregroundStyle(.gray)
                }
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFill()
                .foregroundStyle(.chepicsPrimary)
                .padding(12)
                .frame(width: scale.scaleValue, height: scale.scaleValue)
                .background(.chepicsPrimary.opacity(0.4))
                .clipShape(Circle())
        }
    }
}

#Preview {
    UserIconView(url: nil, scale: .profile)
}
