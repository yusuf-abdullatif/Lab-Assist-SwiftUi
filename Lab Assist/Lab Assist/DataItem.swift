//
//  Item.swift
//  test
//
//  Created by Yusuf Abdullatif on 2024-03-08.
//
import Foundation
import SwiftData

@Model
class UserData: Identifiable {

  var id: UUID // Unique identifier (recommended)
  var username: String
  var password: String
  var remembered: Bool = false

  // One-to-many relationship with QueueData (optional property)
  var queue: [QueueData]?  // Array of QueueData objects (optional)
    
    /*func addToQueue(queueData: QueueData) {
       queue.append(queueData)
       queueData.user = self  // Manually set the user reference in QueueData
     }*/

  init(username: String, password: String, remembered: Bool = false) {
    self.id = UUID()
    self.username = username
    self.password = password
    self.remembered = remembered
  }
}

// QueueData.swift

@Model
class QueueData: Identifiable {

  var id: UUID // Unique identifier (recommended)
  var userId: UUID // Foreign key referencing UserData

  // Optional property for labGroup (consider using an enum for specific groups)
  var labGroup: String?

  // Relationship with UserData (inverse relationship)
  var user: UserData?  // Reference to the associated UserData object

  init(userId: UUID, labGroup: String? = nil) {
    self.id = UUID()
    self.userId = userId
    self.labGroup = labGroup
  }
}
