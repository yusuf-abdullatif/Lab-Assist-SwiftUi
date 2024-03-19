import Foundation
import Observation
import Combine
import SwiftData

class LabModel: ObservableObject {
    @Published private(set) var labData: LabData?
    var isLoading = false
    
    func loadFeed() async throws {
        isLoading = true
        do {
            try await LabDataService.shared.fetchLabData()
            DispatchQueue.main.async {
                self.labData = LabDataService.shared.labData
            }
            print("Successfully fetched and set lab data")
        } catch {
            print("Error loading data: \(error)")
        }
        isLoading = false
    }
    
    func removeUserFromQueue(roomId: Int, userId: Int) {
        guard let roomIndex = labData?.rooms.firstIndex(where: { $0.roomId == roomId }) else {
            return
        }
        
        labData?.rooms[roomIndex].queue.removeAll { $0.userId == userId }
        DispatchQueue.main.async { // Switch to the main thread
            self.objectWillChange.send()
        }
    }
    
    // Method to update the user's isInQueue status
    private func updateUserInQueueStatus(userId: Int, isInQueue: Bool) {
        if let userIndex = labData?.users.firstIndex(where: { $0.id == userId }) {
            // Ensure labData is mutable
            var updatedUsers = labData?.users ?? []
            updatedUsers[userIndex].isInQueue = isInQueue
            labData?.users = updatedUsers
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        } else {
            print("User with ID \(userId) not found")
        }
    }
    
    // Method to add a user to the queue
    func addUserToQueue(userId: Int, roomId: Int, labGroup: Int) {
        guard let roomIndex = labData?.rooms.firstIndex(where: { $0.roomId == roomId }) else {
            print("Room with ID \(roomId) not found")
            return
        }
        
        // Check if the user is already in the queue
        let isInQueue = labData?.rooms[roomIndex].queue.contains(where: { $0.userId == userId }) ?? false
        if !isInQueue {
            // Add the user to the queue if not already present
            labData?.rooms[roomIndex].queue.append(QueueItem(userId: userId, labGroup: labGroup))
            // Set the isInQueue property of the user to true
            updateUserInQueueStatus(userId: userId, isInQueue: true)
        } else {
            print("User \(userId) is already in the queue")
        }
    }
}
