//
//  QueueView.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//

import SwiftUI

struct UserQueueView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if appState.isPasswordEntered {
                if let loggedInUser = appState.loggedInUser, loggedInUser.isInQueue {
                    Text("You are in the queue.")
                } else {
                    Text("You are not in the queue.")
                }
                
                // List of users in the queue
                if let labData = appState.labModel.labData {
                    ForEach(labData.rooms, id: \.roomId) { room in
                        if room.roomId == appState.currentRoomId {
                            Spacer()
                            Text("Room \(room.roomId)")
                                .font(Font.custom("SF Pro", size: 20).weight(.regular))
                            Text("\(room.queue.filter { $0.userId != appState.loggedInUser?.id || (appState.loggedInUser?.isInQueue ?? false) }.count) people in queue")
                                .font(Font.custom("SF Pro", size: 20).weight(.regular))
                            List {
                                // Display other users in the queue
                                let filteredQueue = room.queue.filter { $0.userId != appState.loggedInUser?.id }
                                ForEach(filteredQueue.indices, id: \.self) { index in
                                    let userInQueue = filteredQueue[index]
                                    if let user = labData.users.first(where: { $0.id == userInQueue.userId }) {
                                        // Add 1 to index to display the position in the queue starting from 1
                                        let positionInQueue = index + 1
                                        HStack {
                                            Text("\(positionInQueue). \(user.name)")
                                            Spacer()
                                            Text("Group: \(user.labGroup)")
                                        }
                                    }
                                }
                                // Include the loggedInUser in the queue list if in queue
                                if let loggedInUser = appState.loggedInUser, loggedInUser.isInQueue {
                                    if let userIndex = room.queue.firstIndex(where: { $0.userId == loggedInUser.id }) {
                                        let positionInQueue = userIndex + 1
                                        if let user = labData.users.first(where: { $0.id == loggedInUser.id }) {
                                            HStack {
                                                Text("\(positionInQueue). \(user.name)")
                                                Spacer()
                                                Text("Group: \(user.labGroup)")
                                            }
                                        }
                                    }
                                }
                            }

                            Spacer()
                                .listStyle(.plain)
                            HStack {
                                // Button to join the queue
                                if let loggedInUser = appState.loggedInUser, !loggedInUser.isInQueue {
                                    Button(action: {
                                        appState.joinQueueForCurrentUser()
                                    }) {
                                        Image("JoinQueue")
                                    }
                                }
                                
                                // Button to leave the queue
                                if let loggedInUser = appState.loggedInUser, loggedInUser.isInQueue {
                                    Button(action: {
                                        appState.leaveQueueForCurrentUser()
                                    }) {
                                        Image("LeaveQueue")
                                    }
                                }
                            }
                            // Button to leave the room
                            Button(action: {
                                // Implement leaving the room logic here
                                appState.currentRoomId = 0
                                appState.isPasswordEntered = false
                            }) {
                                Image("LeaveRoom")
                            }
                        }
                    }
                } else {
                    Text("Data not loaded.")
                }
            } else {
                Text("Not in a room, want to join one?")
                Image("NotinQueue")
                    .offset(y: 0)
            }
        }
        .task {
            if appState.loadUserFeed{
                try? await appState.labModel.loadFeed()
                appState.loadUserFeed = false
            }
        }
    }
}


struct StudentsInQueueView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if appState.labModel.isLoading {
                ProgressView()
            } else {
                if let labData = appState.labModel.labData {
                    ForEach(labData.rooms, id: \.roomId) { room in
                        if room.roomId == appState.currentRoomId {
                            Spacer()
                            Text("Room \(room.roomId)")
                                .font(Font.custom("SF Pro", size: 20).weight(.regular))
                            if let loggedInUser = appState.loggedInUser, loggedInUser.isInQueue {
                                Text("\(room.queue.filter { $0.userId != appState.loggedInUser?.id || (appState.loggedInUser?.isInQueue ?? false) }.count) people in queue")
                                    .font(Font.custom("SF Pro", size: 20).weight(.regular))
                                List {
                                    ForEach(Array(room.queue.enumerated()), id: \.element.userId) { (index, userInQueue) in
                                        if let user = labData.users.first(where: { $0.id == userInQueue.userId }), user.id != loggedInUser.id {
                                            // Only include users in the queue, excluding the logged-in user
                                            if user.isInQueue {
                                                HStack {
                                                    Text("\(index + 1). \(user.name)")
                                                    Spacer()
                                                    Text("Group: \(user.labGroup)")
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                Text("You are not in the queue.")
                            }
                            Spacer()
                                .listStyle(.plain)
                        }
                    }
                } else {
                    Text("Data not loaded.")
                }
            }
        }
    }
}

struct StudentsNotInQueueView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Text("Not in a room, want to join one?")
            Image("NotinQueue")
                .offset(y: 0)
            // Add a button to join the queue
            Button(action: {
                appState.joinQueueForCurrentUser()
                // Make sure to navigate to the queue view after joining the queue
                appState.shouldNavigateToQueue = true
            }) {
                Text("Join Queue")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

struct UserQueueView_Previews: PreviewProvider {
    static var previews: some View {
        UserQueueView()
            .environmentObject(AppState())
    }
}
