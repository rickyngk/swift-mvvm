//
//  MvvmViewModelProtocol.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/17/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MvvmViewState {}

class MvvmViewStateNull: MvvmViewState {
    static let sharedInstance = MvvmViewStateNull()
}

protocol MvvmViewModelProtocol: class {
    func execute(command:Any, data:AnyObject?) -> Void;
    func getViewState() -> MvvmViewState;
    func setViewState(viewstate: MvvmViewState) -> Void;
    var viewStateStream:PublishSubject<(MvvmViewState, MvvmViewState)> {get}
}