//
//  TroovApp.swift
//  Troov
//
//  Created by Leo on 18.10.22.
//

import SwiftUI

@main
struct TroovApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }

    init() { initTasks() }
    
    private func initTasks() {
        TApperance.setup()
        DataDog.initialize()
    }
}
