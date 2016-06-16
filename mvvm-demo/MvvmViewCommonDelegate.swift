//
//  MvvmViewCommonDelegate.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 6/16/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation

protocol MvvmViewCommonDelegate {
    var viewModel:MvvmCommonViewModel? {set get}
    
    func onMvvmViewStateInit(viewState: MvvmViewState)
    func onMvvmViewStateUpdated(viewState: MvvmViewState)
    func onMvvmViewStateChanged(newViewState: MvvmViewState, oldViewState: MvvmViewState)
    
    func injectViewModel(viewModel: MvvmCommonViewModel) -> MvvmCommonViewModel
}