//
//  UserCell.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/25.
//

import SwiftUI

struct UserCell: View {
    @Environment(\.colorScheme) var colorScheme
    let user: User
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                UserIconView(url: user.profileImageUrl, scale: .user)
                
                VStack(alignment: .leading) {
                    Text(user.fullname)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    Text("@\(user.username)")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    
                    if let bio = user.bio {
                        Text(bio)
                            .lineLimit(2)
                            .font(.footnote)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    }
                }
                
                Spacer()
            }
            .padding()
            
            Divider()
        }
    }
}

#Preview {
    UserCell(user: mockUser1)
}
