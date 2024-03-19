import SwiftUI
import SwiftData

struct LoginPageView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @EnvironmentObject var appState: AppState
    @State private var labData: LabData?
    @Environment(\.modelContext) private var context
    @State private var shouldNavigateToStudent = false
    
    @Query private var items: [UserData]
    
    
    var body: some View {
            VStack {
                Text("Sign In")
                    .font(
                        Font.custom("SF Pro", size: 40)
                            .weight(.semibold)
                    )
                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                    .frame(width: 340, alignment: .topLeading)
                
                TextField("Username", text: $username)
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 20))
                    .frame(width: 340, height: 47)
                    .background(Color(red: 0.98, green: 0.98, blue: 0.98).opacity(0.5))
                    .cornerRadius(21)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onAppear {
                        // Pre-fill the username if available WORKS WITH ADMIN ONLY so far 
                        if appState.rememberMe, !items.isEmpty {
                            username = items.first!.username  // Access the username of the first user
                        }
                        if !appState.rememberMe {
                            username = ""  // Clear username if rememberMe is unchecked
                            password = ""  // Clear password as well
                            DeleteUser()
                        }
                    }
                
                
                SecureField("Password", text: $password)
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 20))
                    .frame(width: 340, height: 47)
                    .background(Color(red: 0.98, green: 0.98, blue: 0.98).opacity(0.5))
                    .cornerRadius(21)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onAppear {
                        // Pre-fill the username if available
                        if appState.rememberMe, !items.isEmpty {
                            password = items.first!.password  // Access the username of the first user
                        }
                    }
                
                Toggle("Remember Me", isOn: $appState.rememberMe)
                    .frame(width: 340, height: 47)
                    .foregroundColor(.black)
                
                /*NavigationLink(destination: AdminRoomView(selectedTab: .constant("One")), isActive: $shouldNavigateToAdmin) {
                 EmptyView()
                 }
                 .hidden()*/
                
                NavigationLink(destination: ContentView(), isActive: $appState.shouldNavigateToAdmin) {
                    EmptyView()
                }
                
                NavigationLink(destination: ContentView(), isActive: $shouldNavigateToStudent) {
                    EmptyView()
                }
                .hidden()
                
                
                Button(action: {
                    guard let labData = appState.labModel.labData else {
                        showAlert = true
                        return
                    }
                    
                    if let user = labData.users.first(where: { $0.username.lowercased() == username.lowercased() && $0.password == password }) {
                        appState.loggedInUser = user
                        appState.loggedInOnce = true
                        DeleteUser()
                        
                        if appState.rememberMe {
                            addUser(
                                username: appState.loggedInUser?.username ?? "",
                                password: appState.loggedInUser?.password ?? "",
                                remembered: appState.rememberMe
                            )
                        }
                        
                        if user.isAdmin {
                            appState.shouldNavigateToAdmin = true
                            print("Admin Login")
                        } else {
                            shouldNavigateToStudent = true
                            print("Student Login")
                        }
                    } else {
                        showAlert = true
                    }
                }) {
                    ZStack {
                        Image("LoginButton")
                            .padding()
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Credentials"), message: Text("Please check your username and password"), dismissButton: .default(Text("OK")))
                }
            }
            .onAppear {
                loadData()
                
            }
            .frame(width: 393, height: 852, alignment: .center)
            .offset(y: -50)
            .background(Color(red: 0.58, green: 0.11, blue: 0.5))
            
        .navigationBarHidden(true)
        
        
    }
    private func loadData() {
        Task {
            do {
                try await appState.labModel.loadFeed()
                labData = appState.labModel.labData
                
            } catch {
                print("Error loading data: \(error)")
            }
        }
    }
    func addUser(username: String, password: String, remembered: Bool){
        let item = UserData(username: username, password: password, remembered: appState.rememberMe)
        context.insert(item)
        print(item.username)
    }
    func DeleteUser() {
        do {
            for item in items {
                context.delete(item)
            }
            
            // Save changes to the persistent store
            try context.save()
            print("All users deleted successfully")
        } catch {
            print("Error deleting users: \(error)")
            // Handle the error appropriately (e.g., show an alert to the user)
        }
    }
    
}

#Preview {
    LoginPageView()
}
