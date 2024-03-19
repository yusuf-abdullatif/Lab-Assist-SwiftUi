//
//  Lab_AssistTests.swift
//  Lab AssistTests
//
//  Created by Yusuf Abdullatif on 2024-02-09.
//

import XCTest
@testable import Lab_Assist

class AppStateTests: XCTestCase {
    
    let mockUser = User(id: 1,
                        username: "testUser",
                        password: "password123",
                        name: "Test User",
                        labGroup: 1,
                        university: "Test University",
                        isAdmin: false,
                        isInQueue: false)
    
    
    var appState: AppState!
    
    override func setUp() {
        super.setUp()
        appState = AppState()
    }
    
    func testStartTimer() {
        // Setup
        let durationInMinutes = 1
        
        // Execute
        appState.startTimer(durationInMinutes: durationInMinutes)
        
        // Verify
        XCTAssertEqual(appState.remainingTimeInSeconds, durationInMinutes * 60, "Timer should be set with correct remaining seconds.")
        XCTAssertNotNil(appState.timerSubscription, "Timer subscription should be active.")
    }
    
    func testInitialState() {
        let appState = AppState()
        XCTAssertFalse(appState.isLoggedIn, "User should not be logged in by default.")
        XCTAssertFalse(appState.shouldNavigateToAdmin, "Should not navigate to admin view by default.")
        // Add assertions for other initial state properties as needed
    }
    
    func testUserLoginStatus() {
        let appState = AppState()
        
        // Scenario 1: User is not logged in
        appState.loggedInUser = nil
        XCTAssertFalse(appState.isLoggedIn, "isLoggedIn should be false when no user is logged in.")
        
        // Scenario 2: User is logged in
        appState.loggedInUser = mockUser // Using the mockUser here
        XCTAssertTrue(appState.isLoggedIn, "isLoggedIn should be true when a user is logged in.")
    }
    
    
    
    func testLabModelInitialization() {
        let labModel = LabModel()
        XCTAssertNotNil(labModel)
    }
    
    
    func testTimerStartsCorrectly() {
        let durationInMinutes = 10
        appState.startTimer(durationInMinutes: durationInMinutes)
        XCTAssertEqual(appState.remainingTimeInSeconds, durationInMinutes * 60, "Timer should start with the correct duration.")
    }
    
    
    func testResetStateForLogout() {
        // Set various AppState properties to simulate a logged-in state
        appState.loggedInUser = User(id: 1, username: "test", password: "pass", name: "Test User", labGroup: 1, university: "Test Uni", isAdmin: false, isInQueue: true)
        appState.isPasswordEntered = true
        // Reset state
        appState.resetStateForLogout()
        XCTAssertNil(appState.loggedInUser, "loggedInUser should be nil after logout.")
        XCTAssertFalse(appState.isPasswordEntered, "isPasswordEntered should be false after logout.")
        // Add more assertions as needed for other properties reset by resetStateForLogout
    }
    
}


class LabAssistTests: XCTestCase {
    
    func testLabModelInitialization() {
        let labModel = LabModel()
        XCTAssertNotNil(labModel, "LabModel should be successfully initialized.")
    }
    
    func testUserLoginStatus_NotLoggedIn() {
        let appState = AppState()
        appState.loggedInUser = nil
        XCTAssertFalse(appState.isLoggedIn, "isLoggedIn should be false when no user is logged in.")
    }
    
    func testUserLoginStatus_LoggedIn() {
        let appState = AppState()
        let mockUser = User(id: 1, username: "testUser", password: "password123", name: "Test User", labGroup: 1, university: "Test University", isAdmin: false, isInQueue: false)
        appState.loggedInUser = mockUser
        XCTAssertTrue(appState.isLoggedIn, "isLoggedIn should be true when a user is logged in.")
    }
    
    func testJoinQueueForCurrentUser() {
        let appState = AppState()
        // Mock the currentRoomId and loggedInUser for this test
        appState.currentRoomId = 1
        let mockUser = User(id: 1, username: "testUser", password: "password123", name: "Test User", labGroup: 1, university: "Test University", isAdmin: false, isInQueue: false)
        appState.loggedInUser = mockUser
        
        // Assuming there's a method to simulate adding a user to a queue
        appState.joinQueueForCurrentUser()
        
        // Verify
        XCTAssertTrue(appState.loggedInUser?.isInQueue ?? false, "User should be in the queue after joining.")
    }
    
    func testLeaveQueueForCurrentUser() {
        let appState = AppState()
        // Mock the loggedInUser for this test
        let mockUser = User(id: 1, username: "testUser", password: "password123", name: "Test User", labGroup: 1, university: "Test University", isAdmin: false, isInQueue: true)
        appState.loggedInUser = mockUser
        
        // Assuming there's a method to simulate removing a user from a queue
        appState.leaveQueueForCurrentUser()
        
        // Verify
        XCTAssertFalse(appState.loggedInUser?.isInQueue ?? true, "User should not be in the queue after leaving.")
    }
}

class RoomCodeValidatorActorTests: XCTestCase {


    func testInvalidRoomId() async {
        let roomCodeValidator = RoomCodeValidatorActor()
        // Assuming `999` is an invalid room ID for the test case
        let isValid = await roomCodeValidator.isValidRoomId(roomId: 999)
        XCTAssertFalse(isValid, "Room ID 999 should be invalid.")
    }
}

class LabDataServiceTests: XCTestCase {

    func testFetchLabDataSuccess() async throws {
        let labDataService = LabDataService.shared
        do {
            try await labDataService.fetchLabData()
            XCTAssertNotNil(labDataService.labData, "Lab data should not be nil after successful fetch.")
        } catch {
            XCTFail("Fetching lab data should not fail.")
        }
    }

}

class LabModelTests: XCTestCase {

    var labModel: LabModel!
    
    override func setUp() {
        super.setUp()
        labModel = LabModel()
        // Mock the LabDataService to return predefined data instead of making a network request
    }

    func testLoadFeedSuccess() async {
        // Assuming the mock data includes lab data
        do {
            try await labModel.loadFeed()
            XCTAssertNotNil(labModel.labData, "Lab data should be loaded successfully.")
        } catch {
            XCTFail("Loading feed should succeed.")
        }
    }

}
