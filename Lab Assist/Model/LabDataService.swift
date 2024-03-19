//
//  LabDataService.swift
//  Lab Assist
//
//  Created by Melissa Melin on 2024-03-10.
//

import Foundation

class LabDataService {
    static let shared = LabDataService() // Singleton instance
    private(set) var labData: LabData?
    private let baseUrl = "https://tradelinetr.com/api/"
    private let labUrl = "Output.json"

    private init() {}

    func fetchLabData() async throws {
        guard let url = URL(string: baseUrl + labUrl) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        self.labData = try JSONDecoder().decode(LabData.self, from: data)
    }
}
