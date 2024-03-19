//
//  LabData.swift
//  Lab Assist
//
//  Created by Melissa Melin on 2024-03-05.
//

import Foundation

struct LabData: Decodable {
    var users: [User]
    var rooms: [Room]
}
