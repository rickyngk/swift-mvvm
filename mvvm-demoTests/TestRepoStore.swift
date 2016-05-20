//
//  RepoStore.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import mvvm_demo

class TestRepoStore: XCTestCase {
    
    private let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        let p = RepoStoreImpl()
        XCTAssertNotNil(p)
    }
    
    func testFetchDate() {
        let expectation = expectationWithDescription("subscribeNext called")
        let p = RepoStoreImpl()
        p.fetchRepo("swift")
            .driveNext({(repos) in
                XCTAssertNotNil(repos)
                expectation.fulfill()
            })
            .addDisposableTo(bag)
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
