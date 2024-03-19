//
//  AdminQueueView.swift
//  Lab Assist
//
//  Created by Melissa Melin on 2024-03-06.
//
import SwiftUI

struct AdminQueueView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var model: LabModel
    
    var body: some View {
        VStack {
            if appState.isPasswordEntered {
                AdminInQueueView()
            } else {
                AdminNotInQueueView()
            }
        }
    }
}

struct AdminInQueueView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var model: LabModel
    
    var body: some View {
        VStack {
            if model.isLoading {
                ProgressView()
            } else {
                if let labData = model.labData {
                    ForEach(labData.rooms, id: \.roomId) { room in
                        if room.roomId == appState.currentRoomId {
                            Spacer()
                            Text("Room \(room.roomId)")
                                .font(Font.custom("SF Pro", size: 20).weight(.regular))
                            Text("\(room.queue.count) people in queue")
                                .font(Font.custom("SF Pro", size: 20).weight(.regular))
                            List {
                                ForEach(Array(room.queue.enumerated()), id: \.element.userId) { (index, userInQueue) in
                                    if let user = labData.users.first(where: { $0.id == userInQueue.userId }) {
                                        HStack {
                                            Text("\(index + 1). \(user.name)")
                                            Spacer()
                                            Text("Group: \(user.labGroup)")
                                        }
                                        .background(appState.selectedUserId == user.id ? Color.blue.opacity(0.2) : Color.clear)
                                        .cornerRadius(5)
                                        .swipeActions {
                                            Button("Done") {
                                                let roomId = appState.currentRoomId
                                                if let userId = appState.selectedUserId {
                                                    model.removeUserFromQueue(roomId: roomId, userId: userId)
                                                    appState.selectedUserId = nil
                                                    appState.timerActive = false
                                                }
                                            }
                                            .tint(.red)

                                            Button("Start") {
                                                // Retain the Start functionality here
                                                appState.selectedUserId = user.id
                                                appState.timerActive = true
                                                appState.timerDuration = 600

                                                if let selectedIndex = room.queue.firstIndex(where: {$0.userId == user.id}) {
                                                    appState.studentsAfterSelected = max(room.queue.count - (selectedIndex + 1), 0)
                                                }
                                            }
                                            .tint(.green)
                                        }
                                    }
                                }
                                .onDelete { indices in
                                    indices.forEach { index in
                                        let userToDelete = room.queue[index]
                                        model.removeUserFromQueue(roomId: room.roomId, userId: userToDelete.userId)
                                    }
                                }
                                .listStyle(.plain)

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
        .task {
            if appState.loadFeed{
                try? await model.loadFeed()
                appState.loadFeed = false
            }
        }
        Button(action: {
            appState.isPasswordEntered = false
        }) {
            ZStack {
                Image("LeaveRoom")
                    .padding()
            }
        }
    }
}


struct AdminNotInQueueView: View {
    var body: some View {
        Text("Not in a room, want to create one?")
        Image("NotinQueueAdmin")
            .offset(y: 0)
    }
}

struct AdminQueueView_Previews: PreviewProvider {
    static var previews: some View {
        
        AdminQueueView()
    }
}
