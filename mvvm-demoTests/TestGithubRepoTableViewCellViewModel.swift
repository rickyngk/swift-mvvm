//
//  TestGithubRepoTableViewCellViewModel.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/19/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import mvvm_demo

class TestGithubRepoTableViewCellViewModel: XCTestCase {
    
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExecuteUpdateDataData() {
        let expectation = expectationWithDescription("subscribeNext called")
        let viewModel = GithubRepoTableViewCellViewModel()
        viewModel.viewStateStream.subscribeNext { (state) in
            let newState = state.0 as! GithubRepoTableViewCellViewState
            if newState.name == "test" {
                expectation.fulfill()
            }
        }
        .addDisposableTo(bag)
        
        let r = Repo()
        r.full_name = "test"
        viewModel.execute(GithubRepoTableViewCellViewModel.Command.UpdateData, data: r)
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
