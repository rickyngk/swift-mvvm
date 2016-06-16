//
//  GithubRepoTableViewCell.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GitHubRepoTableViewCell: MvvmUITableViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.injectViewModel(GithubRepoTableViewCellViewModel());
    }
    
    func updateCell(repo:Repo) {
        self.viewModel?.execute(GithubRepoTableViewCellViewModel.Command.UpdateData, data: repo)
    }
}

extension GitHubRepoTableViewCell: MvvmViewCommonDelegate {
    
    func onMvvmViewStateInit(viewState: MvvmViewState) {}
    func onMvvmViewStateChanged(newViewState: MvvmViewState, oldViewState: MvvmViewState) {}
    
    func onMvvmViewStateUpdated(viewState: MvvmViewState) {
        let viewState = viewState as! GithubRepoTableViewCellViewState
        self.repoName.text = viewState.name
    }
}

