//
//  RoomData.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//

import Foundation

struct Room: Decodable {
    var roomId: Int
    var queue: [QueueItem]
}

struct QueueItem: Decodable, Identifiable {
    var id: Int { userId } // Conforming to Identifiable protocol
    var userId: Int
    var labGroup: Int
}
