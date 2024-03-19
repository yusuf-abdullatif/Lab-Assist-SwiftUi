//
//  StudentData.swift
//  Lab Assist
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//

import Foundation

struct User: Codable {
    var id: Int
    var username: String
    var password: String
    var name: String
    var labGroup: Int
    var university: String
    var isAdmin: Bool
    var isInQueue: Bool
}

