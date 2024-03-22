//
//  ProfileView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/22.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        KFImage(URL(string: mockTopicImage1.url))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("フォローする")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color(.chepicsPrimary))
                                }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("太郎")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        
                        Text("@aabbcc")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Text("動物に関するトピックを投稿しています\nよろしく")
                        .font(.caption)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        HStack(spacing: 4) {
                            Text("20")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            Text("フォロー")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Text("20")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            Text("フォロワー")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                headerTab
            }
            
            Spacer()
        }
    }
    
    private var headerTab: some View {
        HStack(spacing: 0) {
            ForEach(ProfileTabType.allCases, id: \.self) { type in
                Button {
                    viewModel.selectTab(type: type)
                } label: {
                    VStack {
                        Text(type.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Rectangle()
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(viewModel.selectedTab == type ? Color.getDefaultColor(for: colorScheme) : .gray)
                }

            }
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(profileUseCase: ProfileUseCase_Previews()))
}
