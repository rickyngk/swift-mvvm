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
    var onViewStateChanged: ((ViewModelProtocol, ViewState, ViewState?) -> ())?
    var viewStateStream = PublishSubject<(ViewState, ViewState)>()
    
    var viewState:T?  {
        willSet(newState) {
            let ns:ViewState = newState as! ViewState
            let current = self.viewState as? ViewState
            if (current == nil) {
                viewStateStream.onNext((ns, ViewStateNull.sharedInstance))
            } else {
                viewStateStream.onNext((ns, current!))
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