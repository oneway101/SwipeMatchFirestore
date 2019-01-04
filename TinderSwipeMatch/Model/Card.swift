//
//  Card.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/28/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit

struct Card: CardViewModelDelegate {
    let name: String
    let calorie: Int
    let imageNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(
            string: "\(name)",
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .heavy)])
        attributedText.append(NSAttributedString(
            string: "\n\(calorie)cal",
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)]))
        return CardViewModel(imageNames: imageNames, attributedText: attributedText, textAlignment: .left)

    }
}

