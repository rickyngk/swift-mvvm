//
//  MvvmCommonViewModel.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MvvmCommonViewModel: MvvmViewModelProtocol {
    var viewStateStream = PublishSubject<(MvvmViewState, MvvmViewState)>()
    var _oldState: MvvmViewState?
    var disposeBag = DisposeBag()
    
    var viewState:MvvmViewState?  {
        willSet(newState) {
            _oldState = self.viewState
        }
        didSet {
            if (_oldState == nil) {
                viewStateStream.onNext((self.viewState!, MvvmViewStateNull.sharedInstance))
            } else {
                viewStateStream.onNext((self.viewState!, _oldState!))
            }
        }
    }
    
    func execute(command:Any, data:AnyObject? = NSNull()) {}
    
    func getViewState() -> MvvmViewState {
        return viewState!
    }
    
    func setViewState(vs: MvvmViewState) {
        self.viewState = vs
    }
}




