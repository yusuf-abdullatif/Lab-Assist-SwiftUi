//
//  ContentView.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "One"
    @State private var peopleInFront = 5
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if !appState.isLoggedIn {
            LoginPageView()
        } else if appState.shouldNavigateToAdmin {
            adminNavigationView()
        } else {
            userNavigationView()
        }
    }

    @ViewBuilder
    private func adminNavigationView() -> some View {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    AdminRoomView(selectedTab: $selectedTab)
                        .navigationBarTitle("Room", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Room")
                                    .font(
                                        Font.custom("SF Pro", size: 29)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .tabItem {
                    Image("RoomIcon")
                }.tag("One")
                
                NavigationStack {
                    AdminQueueView()
                        .navigationBarTitle("Queue", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Queue")
                                    .font(
                                        Font.custom("SF Pro", size: 29)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .tabItem {
                    Image("QueueIcon")
                }
                .tag("Two")
                
                NavigationStack {
                    AdminTimeView()
                        .navigationBarTitle("Time", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Time")
                                    .font(
                                        Font.custom("SF Pro", size: 29)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .tabItem {
                    Image("TimeIcon")
                }
                
                NavigationStack {
                    AdminProfileView()
                        .navigationBarTitle("Profile", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Profile")
                                    .font(
                                        Font.custom("SF Pro", size: 29)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .tabItem {
                    Image("ProfileIcon")
                }
            }            .tint(.primary)
        
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func userNavigationView() -> some View {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    UserRoomView(selectedTab: $selectedTab)
                        .navigationBarTitle("Room", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Room")
                                    .font(
                                        Font.custom("SF Pro", size: 29)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .tabItem {
                    Image("RoomIcon")
                }.tag("One")
                
                NavigationStack {
                    UserQueueView()
                        .navigationBarTitle("Queue", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Queue")
                                    .font(
                                        Font.custom("SF Pro", size: 29)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .tabItem {
                    Image("QueueIcon")
                }
                .tag("Two")
                
                NavigationStack {
                    UserTimeView()
                        .navigationBarTitle("Time", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Time")
                                    .font(
                                        Font.custom("SF Pro", size: 29)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .tabItem {
                    Image("TimeIcon")
                }
                
                NavigationStack {
                    UserProfileView()
                        .navigationBarTitle("Profile", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Profile")
                                    .font(
                                        Font.custom("SF Pro", size: 29)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .tabItem {
                    Image("ProfileIcon")
                }
            }
            .tint(.primary)
        .navigationBarHidden(true)
    }
}

#Preview {
    ContentView()
}

