//
//  CommonViewModel.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import XCTest
@testable import mvvm_demo

class CommonViewModel: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAction() {
        let viewModel = TestCommonViewModel()
        viewModel.setViewState(TestCommonViewState(name: "1"))
        XCTAssert((viewModel.getViewState() as! TestCommonViewState).name == "1")
        viewModel.execute(TestCommonViewModel.Command.UpdateData, data: "2")
        XCTAssert((viewModel.getViewState() as! TestCommonViewState).name == "2")
    }

}
