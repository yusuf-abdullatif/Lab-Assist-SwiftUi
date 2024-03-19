//
//  Function1.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//
import Combine
import Foundation

class AppState: ObservableObject {
    @Published var isPasswordEntered = false
    @Published var shouldNavigateToAdmin = false
    @Published var shouldNavigateToQueue = false
    @Published var currentRoomId = 0
    @Published var timerActive: Bool = false
    @Published var timerDuration: Int = 600 // Example initial duration
    @Published var selectedUserId: Int? = nil
    @Published var studentsAfterSelected: Int = 0
    @Published var labModel = LabModel()
    @Published var loggedInUser: User?
    @Published var loggedInOnce = false
    @Published var remainingTime: Int = 600 // Total remaining time in seconds
    @Published var peopleAheadInQueue: Int = 0
    @Published var rememberMe = false
    @Published var loadFeed = true
    @Published var loadUserFeed = true

    var isLoggedIn: Bool {
        loggedInUser != nil
    }
    
    @Published var remainingTimeInSeconds: Int = 0
        var timer: Timer?
        var timerSubscription: AnyCancellable?

        // Function to start the timer with a specific duration in minutes
        func startTimer(durationInMinutes: Int) {
            // Convert minutes to seconds
            self.remainingTimeInSeconds = durationInMinutes * 60
            
            // Invalidate the existing timer if it's already running
            timer?.invalidate()
            
            // Use a Combine publisher to decrement the remaining time every second
            timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    
                    if self.remainingTimeInSeconds > 0 {
                        self.remainingTimeInSeconds -= 1
                    } else {
                        // Invalidate the timer if the time has elapsed
                        self.timerSubscription?.cancel()
                    }
                }
        }
        
        // Function to stop the timer manually if needed
        func stopTimer() {
            timerSubscription?.cancel()
            // Optional: Reset the remaining time or handle as needed
            // self.remainingTimeInSeconds = 0
        }
    
    // Additional functions like joinQueueForCurrentUser(), leaveQueueForCurrentUser(), etc.
}


extension AppState {
    func joinQueueForCurrentUser() {
        guard let userId = loggedInUser?.id, let labGroup = loggedInUser?.labGroup else { return }
        labModel.addUserToQueue(userId: userId, roomId: currentRoomId, labGroup: labGroup)
        // Update the loggedInUser's isInQueue status
        loggedInUser?.isInQueue = true
        
        // Calculate waiting time for the user and start the timer
        let waitingTime = waitingTimeForCurrentUser()
        startTimer(durationInMinutes: waitingTime)
    }
    
    func leaveQueueForCurrentUser() {
        guard let userId = loggedInUser?.id else { return }
        labModel.removeUserFromQueue(roomId: currentRoomId, userId: userId)
        // Update the loggedInUser's isInQueue status
        loggedInUser?.isInQueue = false
        stopTimer()

    }
}

extension AppState {
    // Method to calculate the waiting time for the currently logged-in user
    func waitingTimeForCurrentUser() -> Int {
        // Ensure the user is logged in and a room is selected
        guard let userId = loggedInUser?.id, currentRoomId > 0 else {
            return 0 // No waiting time if no user is logged in or no room is selected
        }
        
        // Find the current room the user might be in
        guard let room = labModel.labData?.rooms.first(where: { $0.roomId == currentRoomId }) else {
            return 0 // No waiting time if the room is not found
        }
        
        // Find the position of the user in the queue
        if let userIndex = room.queue.firstIndex(where: { $0.userId == userId }) {
            // Calculate the waiting time based on the position in the queue
            // Assuming each person in the queue corresponds to a 10-minute wait
            // The position is adjusted by +1 since arrays are 0-indexed but we count positions from 1
            let peopleAhead = userIndex // Number of people ahead of the user in the queue
            return peopleAhead * 10 // Return waiting time in minutes
        } else {
            return 0 // No waiting time if the user is not found in the queue
        }
    }
}

extension AppState {
    // Resets the AppState to its default values, intended to be called upon user logout
    func resetStateForLogout() {
        isPasswordEntered = false
        shouldNavigateToAdmin = false
        shouldNavigateToQueue = false
        currentRoomId = 0
        timerActive = false
        timerDuration = 600 // Reset to default duration if needed
        selectedUserId = nil
        studentsAfterSelected = 0
        loggedInUser = nil
        remainingTime = 600 // Reset to default
        peopleAheadInQueue = 0
        remainingTimeInSeconds = 0

        // Stop and invalidate the timer
        stopTimer()

        // Clear the labModel if necessary. This depends on whether you want to
        // clear all lab data on logout or keep it persistent across different user sessions.
        // If labModel should be reset:
        // labModel = LabModel() // Re-initialize or clear specific data within labModel
        
        // Reset other relevant parts of the app state here
    }
}
