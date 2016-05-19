//
//  mvvm_demoTestData.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import mvvm_demo

class mvvm_demoTestStores: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let disposeBag = DisposeBag()
        let repoStore:RepoStoreImpl = RepoStoreImpl()
        repoStore.fetchRepo("swift")
            .driveNext { (repo: [Repo]) in
                print("\(repo)")
            }
            .addDisposableTo(disposeBag)
    }

}
