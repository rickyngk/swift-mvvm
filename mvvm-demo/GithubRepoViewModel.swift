//
//  ViewController~ViewModel.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/17/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct GithubRepoViewState: MvvmViewState {
    let isLoading: Bool
    let repoData: [Repo]
    
    init(isLoading:Bool, repoData: [Repo]) {
        self.isLoading = isLoading;
        self.repoData = repoData
    }
}

class GithubRepoViewModel: MvvmCommonViewModel {
    internal enum Command:Int {
        case FetchData = 1
    }
    
    internal var repoStore:RepoStore?
    private let bag = DisposeBag()
    
    
    override func execute(command:Any, data:AnyObject? = NSNull()) {
        let vs = self.viewState as? GithubRepoViewState
        if let command:Command = command as? Command {
            switch command {
            case .FetchData:
                let q:String = data as! String
                if self.viewState == nil {
                    self.viewState = GithubRepoViewState(isLoading: true, repoData: [Repo]())
                } else {
                    self.viewState = GithubRepoViewState(isLoading: true, repoData: vs!.repoData)
                }
                
                self.repoStore!
                    .fetchRepo(q)
                    .driveNext({[unowned self] (repos) in
                        self.viewState = GithubRepoViewState(isLoading: false, repoData: repos)
                    })
                    .addDisposableTo(bag)
                break
            }
        }
    }

    func injectRepoStore(repoStore:RepoStore) -> GithubRepoViewModel {
        self.repoStore = repoStore
        return self
    }
}
