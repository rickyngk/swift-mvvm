//
//  GitHubRepoTableViewCell~ViewModel.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation

import Foundation

struct GithubRepoTableViewCellViewState: MvvmViewState {
    let name:String;
}

class GithubRepoTableViewCellViewModel: MvvmCommonViewModel {
    internal enum Command:Int {
        case UpdateData = 0
    }
    
    override func execute(command:Any, data:AnyObject? = NSNull()) {
        if let command:Command = command as? Command{
            switch command {
            case .UpdateData:
                if let data:Repo = data as? Repo {
                    self.viewState = GithubRepoTableViewCellViewState(name: data.full_name)
                }
                break
            }
        }
    }
}