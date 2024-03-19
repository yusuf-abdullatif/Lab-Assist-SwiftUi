//
//  ProfileView.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//

import SwiftUI

struct UserProfileView: View {
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var model = LabModel()
    @State private var profileImage: String = "ProfileIcon1"
    
    var body: some View {
        VStack {
            Spacer()

            if let loggedInUser = appState.loggedInUser {
                Image(profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .padding(.bottom, 10)
                Text("\(loggedInUser.name)")
                    .font(Font.custom("SF Pro", size: 29).weight(.regular))
                Text("\(loggedInUser.university)")
                    .font(Font.custom("SF Pro", size: 14).weight(.regular))
            } else {
                Text("Non-admin user not found")
            }
            
            Spacer()
            NavigationLink(destination: MyLabGroupsView()) {
                Image("MyLabGroups")
                    .padding(5)
            }
            NavigationLink(destination: InformationView()) {
                Image("Information")
                    .padding(5)
            }
            NavigationLink(destination: EmptyView()) {
                Image("Version")
                    .padding(5)
                    .onTapGesture {
                        showingAlert = true
                    }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Version"), message: Text("Version 1.0.0"), dismissButton: .default(Text("OK")))
            }
            
            Button(action: {
                // Reset the app state to ensure a clean logout
                appState.resetStateForLogout()
                
                // Optionally, navigate the user to the landing or login view
                // This might require adjusting your app's navigation structure or using a @Published property to trigger navigation
            }) {
                Image("Logout")
                    .padding(5)
            }
            Spacer()
        }
        .navigationTitle("User Profile")
        .onAppear {
            Task {
                try? await model.loadFeed()
            }
        }
    }
}


struct MyLabGroupsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            List {
                Section(header:
                    HStack {
                        Text("My Lab Groups")
                    }
                ) {
                    if let userLabGroup = appState.loggedInUser?.labGroup {
                        Text("Lab Group: \(userLabGroup)")
                    } else {
                        Text("No lab group found for user")
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    try await appState.labModel.loadFeed()
                } catch {
                    print("Error loading data: \(error)")
                }
            }
        }
        .navigationBarTitle("Lab Groups", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Lab Groups")
                    .font(Font.custom("SF Pro", size: 29).weight(.regular))
                    .foregroundColor(.white)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct InformationView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isAboutLabAssistExpanded = false
    @State private var isQueueManagementExpanded = false
    @State private var isTimeTrackingExpanded = false
    @State private var isPreventingCheatingExpanded = false
    
    var body: some View {
        VStack {
            List {
                Section(header:
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Information")
                    }
                ) {
                    FeatureDisclosureView(title: "About Lab Assist", description: "Welcome to our Lab Assist! This app aims to simplify the lab queue system for both teachers and students.", isExpanded: $isAboutLabAssistExpanded) // Now uses its own state variable
                }
                
                Section(header:
                    HStack {
                        Image(systemName: "key")
                        Text("Key Features")
                    }
                ) {
                    FeatureDisclosureView(title: "Queue Management", description: "Students can enter a queue with a unique code, allowing them to see how many people are ahead of them and the estimated time remaining.", isExpanded: $isQueueManagementExpanded)
                    
                    FeatureDisclosureView(title: "Time Tracking", description: "Teachers can track the time spent with each student, ensuring no one gets lost or exceeds their allotted time.", isExpanded: $isTimeTrackingExpanded)
                    
                    FeatureDisclosureView(title: "Preventing Cheating", description: "To maintain fairness, students cannot manipulate the queue or bypass the system to favor friends or cheat.", isExpanded: $isPreventingCheatingExpanded)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle("Lab Assist", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Lab Assist")
                    .font(Font.custom("SF Pro", size: 29).weight(.regular))
                    .foregroundColor(.white)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 0.58, green: 0.11, blue: 0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct FeatureDisclosureView: View {
    var title: String
    var description: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading) { // Ensure content aligns to the leading edge.
            Button(action: {
                isExpanded.toggle()
                
            }) {
                HStack {
                    Text(title)
                        .fontWeight(.regular) // Make title bold.
                        .foregroundColor(.primary) // Title in primary color for prominence.
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary) // Chevron in secondary color.
                }
            }

            if isExpanded {
                Text(description)
                    .font(.body) // Standard body font for description.
                    .foregroundColor(.secondary) // Description in secondary color to be less dominant.
                    .padding(.top, 5)
            }
        }
    }
}



struct VersionView: View {
    var body: some View {
        Text("Version")
    }
}


#Preview {
    InformationView()
}
