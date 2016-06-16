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


protocol MvvmViewCommonDelegate {
    var viewModel:CommonViewModel? {set get}
    
    func onMvvmViewStateInit(viewState: ViewState)
    func onMvvmViewStateChanged(newViewState: ViewState, oldViewState: ViewState)
    
    func injectViewModel(viewModel: CommonViewModel) -> CommonViewModel
}

extension MvvmViewCommonDelegate where Self: MvvmUIViewController {
    func injectViewModel(viewModel: CommonViewModel) -> CommonViewModel {
        viewModel.viewStateStream.subscribeNext { (state) in
            let newViewState = state.0
        
            if state.1 is ViewStateNull { //update data table
                self.onMvvmViewStateInit(newViewState)
            } else {
                self.onMvvmViewStateChanged(newViewState, oldViewState: state.1 as ViewState)
            }
        }
        .addDisposableTo(viewModel.disposeBag)
        self.viewModel = viewModel
        return viewModel
    }
}

class MvvmUIViewController: UIViewController {
    var viewModel:CommonViewModel? = nil
}