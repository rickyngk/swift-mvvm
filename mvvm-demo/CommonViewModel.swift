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

class CommonViewModel: ViewModelProtocol {
    var viewStateStream = PublishSubject<(ViewState, ViewState)>()
    var _oldState: ViewState?
    var disposeBag = DisposeBag()
    
    var viewState:ViewState?  {
        willSet(newState) {
            _oldState = self.viewState
        }
        didSet {
            if (_oldState == nil) {
                viewStateStream.onNext((self.viewState!, ViewStateNull.sharedInstance))
            } else {
                viewStateStream.onNext((self.viewState!, _oldState!))
            }
        }
    }
    
    func execute(command:Any, data:AnyObject? = NSNull()) {}
    
    func getViewState() -> ViewState {
        return viewState!
    }
    
    func setViewState(vs: ViewState) {
        self.viewState = vs
    }
}




