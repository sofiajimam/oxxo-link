//
//  LeclercCoreTests.swift
//  LeclercCoreTests
//
//  Created by Omar Sánchez on 23/04/24.
//

import XCTest
@testable import LeclercCore

final class LeclercCoreTests: XCTestCase {
    
    var firestoreManager: FirestoreManager!
    var testUser: User!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        firestoreManager = FirestoreManager()
        testUser = User(id: "testID", name: "Test User", phone: "1234567890")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        firestoreManager = nil
        testUser = nil
        try super.tearDownWithError()
    }
    
    func testCreateUser() throws {
        let expectation = self.expectation(description: "User creation")
        firestoreManager.createUser(user: testUser) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to create user: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // test add medal to user
    func testAddMedalToUser() throws {
        let expectation = self.expectation(description: "Add medal to user")
        firestoreManager.addMedalToUser(userId: testUser.id, medal: Activity(id: "testMedal", name: "Test Medal", description: "Test Medal Description", type: "Medal", date: Date())) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to add medal to user: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
        // test get user medals
    func testGetUserMedals() throws {
        let expectation = self.expectation(description: "Get user medals")
        firestoreManager.getMedalsOfUser(userID: testUser.id) { result in
            switch result {
            case .success(let medals):
                XCTAssertNotNil(medals)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get user medals: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // test add quest to user
    func testAddQuestToUser() throws {
        let expectation = self.expectation(description: "Add quest to user")
        firestoreManager.addQuestToUser(userId: testUser.id, quest: Activity(id:"testQuest", name: "Test Quest", description: "Test Quest Description", type: "Test Type", date: Date())) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to add quest to user: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // test get user quests
    func testGetUserQuests() throws {
        let expectation = self.expectation(description: "Get user quests")
        firestoreManager.getQuestsOfUser(userID: testUser.id) { result in
            switch result {
            case .success(let quests):
                XCTAssertNotNil(quests)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get user quests: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // test add visites feed to user
    func testAddVisitedFeedToUser() throws {
        let expectation = self.expectation(description: "Add visites feed to user")
        firestoreManager.addVisitedFeedToUser(userId: testUser.id, feed: Feed(id:"testFeed", lat: 123, lng: 123, name: "Test name", reactions: 2)) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to add visites feed to user: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    // test add my feed to user
    func testAddMyFeedToUser() throws {
        let expectation = self.expectation(description: "Add my feed to user")
        firestoreManager.addMyFeedToUser(userId: testUser.id, feed: Feed(id: "testFeed", lat: 123, lng: 123, name: "Test name", reactions: 2)) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to add my feed to user: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // test get user visites feeds
    func testGetUserVisitedFeeds() throws {
        let expectation = self.expectation(description: "Get user visites feeds")
        firestoreManager.getVisitedFeedsOfUser(userID: testUser.id) { result in
        switch result {
            case .success(let feeds):
                XCTAssertNotNil(feeds)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get user visites feeds: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    // add event to user
    func testAddEventToUser() throws {
        let expectation = self.expectation(description: "Add event to user")
        firestoreManager.addEventToUser(userId: testUser.id, event: Activity(id: "testEvent", name: "Test Event", description: "Test Event Description", type: "Test Type", date: Date())) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to add event to user: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
        
    // FEED
    
    // test create feed
    func testCreateFeed() throws {
        let expectation = self.expectation(description: "Feed creation")
        firestoreManager.createFeed(feed: Feed(id: "testFeed", lat: 123, lng: 123, name:"Test name", reactions: 2)) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to create feed: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // test get feed
    func testGetFeed() throws {
        let expectation = self.expectation(description: "Get feed")
        firestoreManager.getFeed(feedID: "testFeed") { result in
        switch result {
            case .success(let feed):
                XCTAssertNotNil(feed)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get feed: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // ELEMENT
        
    // test add element to feed
    func testAddElementToFeed() throws {
        let expectation = self.expectation(description: "Add element to feed")
        firestoreManager.addElementToFeed(feedID: "testFeed", element: Element(id:"testElement", description: "Test Element", type: "Test Type",position: Position(x: 0, y: 0, z: 0))) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to add element to feed: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // test get feed elements
    func testGetFeedElements() throws {
        let expectation = self.expectation(description: "Get feed elements")
        firestoreManager.getElementsOfFeed(feedID: "testFeed") { result in
        switch result {
            case .success(let elements):
                XCTAssertNotNil(elements)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get feed elements: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // ACTIVITY
        
    // test create activity
    func testCreateActivity() throws {
        let expectation = self.expectation(description: "Activity creation")
        firestoreManager.createActivity(activity: Activity(id: "testQuest", name: "Test Quest", description: "Test Quest Description", type: "Test Type", date:Date())) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to create activity: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // test get activity
    func testGetActivity() throws {
        let expectation = self.expectation(description: "Get activity")
        firestoreManager.getActivity(activityID: "testQuest") { result in
        switch result {
            case .success(let activity):
                XCTAssertNotNil(activity)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get activity: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // add activity to user
    func testAddActivityToUser() throws {
        let expectation = self.expectation(description: "Add activity to user")
        firestoreManager.addActivityToUser(userID: testUser.id, activity: Activity(id: "testQuest", name: "Test Quest", description: "Test Quest Description",type: "Test Type", date: Date())) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to add activity to user: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // test add activity to feed
    func testAddActivityToFeed() throws {
        let expectation = self.expectation(description: "Add activity to feed")
            firestoreManager.addActivityToFeed(feedID: "testFeed", activity:Activity(id: "testQuest", name: "Test Quest", description: "Test Quest Description", type: "Test Type", date: Date())) { result in
        switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to add activity to feed: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
    // get feed activities of user
    func testGetFeedActivitiesOfUser() throws {
        let expectation = self.expectation(description: "Get feed activities of user")
            firestoreManager.getActivitiesOfUser(userID: testUser.id) { result in
        switch result {
            case .success(let activities):
                XCTAssertNotNil(activities)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get feed activities of user: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
        
        
        func testExample() throws {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct results.
            // Any test you write for XCTest can be annotated as throws and async.
            // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
            // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        }
        
        func testPerformanceExample() throws {
            // This is an example of a performance test case.
            self.measure {
                // Put the code you want to measure the time of here.
            }
        }
        
    }
