//
//  CommonViewModel.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel<T>: ViewModelProtocol {
    var viewStateStream = PublishSubject<(ViewState, ViewState)>()
    private var _oldState: T?
    
    var viewState:T?  {
        willSet(newState) {
            _oldState = self.viewState
        }
        didSet {
            if (_oldState == nil) {
                viewStateStream.onNext((self.viewState as! ViewState, ViewStateNull.sharedInstance))
            } else {
                viewStateStream.onNext((self.viewState as! ViewState, _oldState as! ViewState))
            }
        }
    }
    
    func execute(command:Any, data:AnyObject? = NSNull()) {}
    
    func getViewState() -> ViewState {
        return viewState! as! ViewState
    }
    
    func setViewState(vs: ViewState) {
        self.viewState = vs as? T
    }
}