//
//  ViewModelProtocol.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/17/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewState {}

class ViewStateNull: ViewState {
    static let sharedInstance = ViewStateNull()
}

protocol ViewModelProtocol: class {
    func execute(command:Any, data:AnyObject?) -> Void;
    func getViewState() -> ViewState;
    func setViewState(viewstate: ViewState) -> Void;
    var viewStateStream:PublishSubject<(ViewState, ViewState)> {get}
}