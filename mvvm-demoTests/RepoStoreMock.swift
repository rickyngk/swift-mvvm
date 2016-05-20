//
//  RepoStoreTest.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/19/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
@testable import mvvm_demo

class RepoStoreMock: RepoStore {
    internal func fetchRepo(query: String) -> Driver<[Repo]> {
        let r = Repo()
        r.full_name = "sample 1"
        r.id = 1;
        return Driver.just([Repo](arrayLiteral: r))
    }
}