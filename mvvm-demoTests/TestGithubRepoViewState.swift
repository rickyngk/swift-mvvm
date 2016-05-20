//
//  GithubRepoViewState.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/19/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import mvvm_demo

class TestGithubRepoViewState: XCTestCase {

    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExecuteFetchData() {
        let expectation = expectationWithDescription("subscribeNext called")
        let viewModel = GithubRepoViewModel().injectRepoStore(RepoStoreMock())
        viewModel.viewStateStream.subscribeNext { (state) in
            let newState = state.0 as! GithubRepoViewState
            if !newState.isLoading && newState.repoData.count >= 1 {
                expectation.fulfill()
            }
        }
        .addDisposableTo(bag)
        viewModel.execute(GithubRepoViewModel.Command.FetchData, data: "swift")
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testExecuteFetchDataWithPresetViewState() {
        let expectation = expectationWithDescription("subscribeNext called")
        let viewModel = GithubRepoViewModel().injectRepoStore(RepoStoreMock())
        viewModel.viewStateStream.subscribeNext { (state) in
            let newState = state.0 as! GithubRepoViewState
            if !newState.isLoading && newState.repoData.count >= 1 {
                expectation.fulfill()
            }
            }
            .addDisposableTo(bag)
        viewModel.setViewState(GithubRepoViewState(isLoading: false, repoData: [Repo]()))
        viewModel.execute(GithubRepoViewModel.Command.FetchData, data: "swift")
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
