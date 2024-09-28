//
//  ChatSessionAdminSupport.swift
//  Troov
//
//  Created by Levon Arakelyan on 05.11.23.
//

import Foundation

struct ChatSessionAdminSupport {   
    var state: ChatSession.State
    var adminProfile: UserProfile?
    var adminId: String
}

extension ChatSessionAdminSupport {
    var adminServerImages: [TServerImage] {
        return adminProfile?.profileMedia?.map({ $0.serverImage(by: adminId)}) ?? []
    }
}
