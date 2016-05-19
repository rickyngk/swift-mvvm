//
//  ViewController.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/17/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

class GithubRepoViewController: UIViewController {

    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var query: UITextField!
    
    private let bag = DisposeBag()
    private var tableData = BehaviorSubject<[Repo]>(value: [])
    
    var viewModel:GithubRepoViewModel!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = GithubRepoViewModel().injectRepoStore(RepoStoreImpl())
        
        viewModel.viewStateStream.subscribeNext { (state) in
            let newViewState = state.0 as! GithubRepoViewState
            let oldViewState = state.1 as? GithubRepoViewState
            
            self.myButton.enabled = !newViewState.isLoading
            self.loadingIndicator.hidden = !newViewState.isLoading
            self.loadingIndicator.startAnimating()
            
            if oldViewState == nil || oldViewState!.repoData != newViewState.repoData { //update data table
                self.tableData.onNext(newViewState.repoData)
            }
        }
        .addDisposableTo(self.bag)
        viewModel.setViewState(GithubRepoViewState(isLoading: false, repoData: [Repo]()))
        
        tableData.bindTo(self.tableView.rx_itemsWithCellIdentifier("repoCell")) {
            (index, repo: Repo, cell:GitHubRepoTableViewCell) in
                cell.updateCell(repo)
        }
        .addDisposableTo(self.bag)
        
        
        query.rx_text.asDriver()
            .filter({!$0.isEmpty})
            .throttle(1.0)
            .distinctUntilChanged()
            .driveNext { (text) in
                self.viewModel.execute(GithubRepoViewModel.Command.FetchData, data: text)
            }
            .addDisposableTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonClicked(sender: AnyObject) {
        viewModel.execute(GithubRepoViewModel.Command.FetchData, data: self.query.text)
    }
}

