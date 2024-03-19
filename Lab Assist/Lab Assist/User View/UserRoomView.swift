//
//  RoomView.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//
import SwiftUI

struct UserRoomView: View {
    @State private var roomCode: String = ""
    @State private var showAlert = false
    @State private var enteredRoomId: Int?
    @EnvironmentObject var appState: AppState
    @Binding var selectedTab: String
    
    let roomCodeValidator = RoomCodeValidatorActor()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter code to join room")
                    .offset(y: -50)
                    .font(Font.custom("SF Pro", size: 20).weight(.regular))
                    .kerning(-0.36)
                
                TextField("Code", text: $roomCode, onCommit: {
                    Task {
                        if let roomId = Int(roomCode), await roomCodeValidator.isValidRoomId(roomId: roomId) {
                            enteredRoomId = roomId
                            appState.currentRoomId = roomId
                            appState.shouldNavigateToQueue = true
                            appState.isPasswordEntered = true
                            print("Entered Queue")
                        } else {
                            showAlert = true
                        }
                    }
                })
                .font(Font.custom("Poppins", size: 15).weight(.light))
                .foregroundColor(.black.opacity(0.7))
                .padding(.leading, 30)
                .foregroundColor(.clear)
                .frame(width: 280, height: 47)
                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                .cornerRadius(21)
                .offset(y: -50)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Code"), message: Text("Invalid Code"), dismissButton: .default(Text("OK")))
                }
                .onChange(of: appState.shouldNavigateToQueue) { newValue in
                    if newValue {
                        selectedTab = "Two"
                        appState.shouldNavigateToQueue = false
                    }
                }
            }
        }
    }
}


/*
#Preview {
    UserRoomView()
}
*/
