//
//  RoomCodeValidatorActor.swift
//  Lab Assist
//
//  Created by Melissa Melin on 2024-03-10.
//

import Foundation

actor RoomCodeValidatorActor {
    private var validRoomIds: Set<Int> = []

    init() {
        // Initialize with an empty set, actual fetching will occur when needed
    }

    func isValidRoomId(roomId: Int) async -> Bool {
        await fetchValidRoomIds() // Ensure the latest data is fetched
        return validRoomIds.contains(roomId)
    }

    private func fetchValidRoomIds() async {
        do {
            try await LabDataService.shared.fetchLabData()
            if let labData = LabDataService.shared.labData {
                // Update validRoomIds with the latest room IDs
                self.validRoomIds = Set(labData.rooms.map(\.roomId))
            }
        } catch {
            print("Error fetching lab data: \(error)")
        }
    }
}
