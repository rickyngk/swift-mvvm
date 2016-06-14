//
//  Mvvm+UIViewController.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 6/14/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


protocol MvvmViewEventDelegate: class {
    func onMvvmViewStateInit(viewState: Any)
    func onMvvmViewStateChanged(newViewState: Any, oldViewState: Any)
}

class MvvmCommonViewController<ViewModelClass, ViewStateStruct>: UIViewController {
    weak var mvvmDelegate:MvvmViewEventDelegate?
    let mvvmBag = DisposeBag()
    var mvvmViewModel:ViewModelClass? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func injectViewModel(viewModel: CommonViewModel<ViewStateStruct>) {
        self.mvvmViewModel = viewModel as? ViewModelClass
        viewModel.viewStateStream.subscribeNext { (state) in
            let newViewState = state.0 as! GithubRepoViewState
            let oldViewState = state.1 as? GithubRepoViewState
            
            if oldViewState == nil { //update data table
                self.mvvmDelegate?.onMvvmViewStateInit(newViewState)
            } else {
                self.mvvmDelegate?.onMvvmViewStateChanged(newViewState, oldViewState: oldViewState)
            }
        }
        .addDisposableTo(self.mvvmBag)

    }
}
