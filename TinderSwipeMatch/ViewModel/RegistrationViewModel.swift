//
//  RegistrationViewModel.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/8/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import Foundation

class RegistrationViewModel {
    
    var fullName: String? { didSet {checkFormValidity()} }
    var email: String? { didSet {checkFormValidity()} }
    var password: String? { didSet {checkFormValidity()} }
    
    fileprivate func checkFormValidity(){
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    // Reactive Programming
    var isFormValidObserver: ((Bool)-> Void)?
}
