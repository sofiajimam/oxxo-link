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
                // As createUser no longer returns the created user, we can't directly assert on its properties.
                // Instead, we can fulfill the expectation here to indicate that the user creation was successful.
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to create user: \(error)")
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
