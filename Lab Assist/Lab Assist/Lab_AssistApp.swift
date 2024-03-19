//
//  Lab_AssistApp.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//

import SwiftUI
import SwiftData

@main
struct Lab_AssistApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var model = LabModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isLoggedIn {
                    ContentView()
                } else if appState.loggedInOnce {
                    LoginPageView()
                }
                else {
                    LandingPageView()
                }
            }
            //LandingPageView()
            .environmentObject(appState)
            .environmentObject(model)
        }    .modelContainer(for: UserData.self)
        
    }
}
