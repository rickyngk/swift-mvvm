//
//  RepoStore.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RepoStore {
    func fetchRepo(filer: String) -> Driver<[Repo]>
}