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

class GitHubRepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    var viewModel:GithubRepoTableViewCellViewModel!
    let bag = DisposeBag();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        viewModel = GithubRepoTableViewCellViewModel()
        viewModel.viewStateStream.subscribeNext { (data) in
                let newViewState = data.0 as! GithubRepoTableViewCellViewState
                self.repoName.text = newViewState.name
            }
            .addDisposableTo(bag);
    }
    
    func updateCell(repo:Repo) {
        self.viewModel.execute(GithubRepoTableViewCellViewModel.Command.UpdateData, data: repo)
    }
}