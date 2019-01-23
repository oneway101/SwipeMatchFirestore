//
//  CardViewModel.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/2/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import UIKit

protocol CardViewModelDelegate {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    // Define the properties that view will display/render out
    let imageNames: [String]
    let attributedText: NSMutableAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedText: NSMutableAttributedString, textAlignment: NSTextAlignment){
        self.imageNames = imageNames
        self.attributedText = attributedText
        self.textAlignment = textAlignment
    }
    
    // Whenever image index value is changing it is notifying the imageIndexObserver
    fileprivate var imageIndex = 0 {
        didSet{
            print("imageIndex: \(imageIndex)")
            // Set the image
            let imageUrl = imageNames[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    // Reactive Programming
    var imageIndexObserver: ((Int, String?)-> Void)?
    
    // Pervent out of the index range using min and max
    func advanceToNextPhoto(){
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto(){
        imageIndex = max(0, imageIndex - 1)
    }
    
}
