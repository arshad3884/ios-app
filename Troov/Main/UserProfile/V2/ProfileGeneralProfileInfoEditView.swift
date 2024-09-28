//
//  ProfileGeneralProfileInfoEditView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 18.09.2023.
//

import SwiftUI

struct ProfileGeneralProfileInfoEditView: View {
    let menuItem: ProfileEditMenuItem
    
    @Binding var selectedInfo: [String]
    
    private var generalInfo: [String] {
        menuItem.generalInfo
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10, content: {
                    ForEach(generalInfo, id: \.self) { info in
                        Button { select(info) } label: {
                            if selectedInfo.contains(info) {
                                TSecondaryLabel(text: info.cleanEnums,
                                                isFilled: true)
                            } else {
                                TTertiaryLabel(text: info.cleanEnums)
                            }
                        }
                        .buttonStyle(.scalable)
                        .padding(1)
                    }
                })
            }
            .padding(.top, 20)
            .padding(.horizontal, 30)
        }
    }
    
    private func select(_ info: String) {
        if menuItem == .ethnicity {
            if let index = selectedInfo.firstIndex(of: info) {
                selectedInfo.remove(at: index)
            } else {
                selectedInfo.append(info)
            }
        } else {
            if selectedInfo.count > 0 {
                selectedInfo[0] = info
            } else {
                selectedInfo.insert(info, at: 0)
            }
        }
    }
}

#Preview {
    ProfileGeneralProfileInfoEditView(menuItem: .education,
                                      selectedInfo: .constant([]))
}
