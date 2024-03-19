//
//  AdminProfileView.swift
//  Lab Assist
//
//  Created by Melissa Melin on 2024-03-06.
//
import SwiftUI

struct AdminProfileView: View {
    
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
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
                    Text("Admin not found")
                }
                Spacer()
                NavigationLink(destination: AdminMyLabGroupsView()) {
                    Image("MyLabGroups")
                        .padding(5)
                }
                NavigationLink(destination: AdminInformationView()) {
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
                    // Call the reset method to clear all user and session-specific state
                    appState.resetStateForLogout()
                    // Additional logic here if you need to navigate the user to a specific view or perform other cleanup tasks
                }) {
                    Image("Logout")
                        .padding(5)
                }
                Spacer()
            }
            .navigationTitle("Admin Profile")
            .onAppear {
                Task {
                    do {
                        try await appState.labModel.loadFeed()
                    } catch {
                        print("Error loading data: \(error)")
                    }
                }
            }
        }
    
}



struct AdminMyLabGroupsView: View {
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


struct AdminInformationView: View {
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
                    AdminFeatureDisclosureView(title: "Queue Management", description: "Students can enter a queue with a unique code, allowing them to see how many people are ahead of them and the estimated time remaining.", isExpanded: $isQueueManagementExpanded)
                    
                    AdminFeatureDisclosureView(title: "Time Tracking", description: "Teachers can track the time spent with each student, ensuring no one gets lost or exceeds their allotted time.", isExpanded: $isTimeTrackingExpanded)
                    
                    AdminFeatureDisclosureView(title: "Preventing Cheating", description: "To maintain fairness, students cannot manipulate the queue or bypass the system to favor friends or cheat.", isExpanded: $isPreventingCheatingExpanded)
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

struct AdminFeatureDisclosureView: View {
    var title: String
    var description: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                isExpanded.toggle()
                
            }) {
                HStack {
                    Text(title)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }

            if isExpanded {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.top, 5)
            }
        }
    }
}

struct AdminVersionView: View {
    var body: some View {
        Text("Version")
    }
}

#Preview {
    InformationView()
}
