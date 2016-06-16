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

class GithubRepoViewController: MvvmUIViewController {
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var query: UITextField!
    
    private var tableData = BehaviorSubject<[Repo]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.injectViewModel(GithubRepoViewModel().injectRepoStore(RepoStoreImpl())).setViewState(GithubRepoViewState(isLoading: false, repoData: [Repo]()))
        tableData.bindTo(self.tableView.rx_itemsWithCellIdentifier("repoCell")) {
            (index, repo: Repo, cell:GitHubRepoTableViewCell) in
                cell.updateCell(repo)
        }
        .addDisposableTo(self.viewModel!.disposeBag)
        
        
        query.rx_text.asDriver()
            .filter({!$0.isEmpty})
            .throttle(1.0)
            .distinctUntilChanged()
            .driveNext { (text) in
                self.viewModel?.execute(GithubRepoViewModel.Command.FetchData, data: text)
            }
            .addDisposableTo((self.viewModel?.disposeBag)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonClicked(sender: AnyObject) {
        self.viewModel?.execute(GithubRepoViewModel.Command.FetchData, data: self.query.text)
    }
}


extension GithubRepoViewController: MvvmViewCommonDelegate {
    
    func onMvvmViewStateInit(viewState: MvvmViewState) {
        let viewState = viewState as! GithubRepoViewState
        self.tableData.onNext(viewState.repoData)
    }
    
    func onMvvmViewStateChanged(newViewState: MvvmViewState, oldViewState: MvvmViewState) {
        let newViewState = newViewState as! GithubRepoViewState
        let oldViewState = oldViewState as! GithubRepoViewState
        if oldViewState.repoData != newViewState.repoData {
            self.tableData.onNext(newViewState.repoData)
        }
    }
    
    func onMvvmViewStateUpdated(viewState: MvvmViewState) {
        let viewState = viewState as! GithubRepoViewState
        
        self.myButton.enabled = !viewState.isLoading
        self.loadingIndicator.hidden = !viewState.isLoading
        self.loadingIndicator.startAnimating()
    }
}








