//
//  RepoStoreImpl.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

class RepoStoreImpl: RepoStore {
    internal func fetchRepo(query: String) -> Driver<[Repo]> {
        let query = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = "https://api.github.com/search/repositories?q=\(query)+in:name";
        
        return JSON(.GET, url)
            .asDriver(onErrorJustReturn: [])
            .map({ json -> [Repo] in
                guard let items = json["items"] as? [AnyObject] else {return []}
                return items.map {Repo(value: $0)}
            })
    }
}