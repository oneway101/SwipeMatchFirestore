//
//  Bindable.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/9/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
