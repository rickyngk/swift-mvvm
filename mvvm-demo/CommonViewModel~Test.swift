//
//  CommonViewModel~Test.swift
//  mvvm-demo
//
//  Created by NGUYEN KHANH DUY on 5/18/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import Foundation

struct TestCommonViewState: ViewState {
    let name:String
}

class TestCommonViewModel: CommonViewModel<TestCommonViewState> {
    internal enum Command:Int {
        case UpdateData = 0
    }
    
    override func execute(command:Any, data:AnyObject? = NSNull()) {
        if let command:Command = command as? Command {
            switch command {
            case .UpdateData:
                if let data:String = data as? String {
                    self.viewState = TestCommonViewState(name: data)
                }
                break
            }
        }
        super.execute(command)
    }
}