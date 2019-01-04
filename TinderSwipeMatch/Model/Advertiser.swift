//
//  Advertiser.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/2/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import UIKit

struct Advertiser: CardViewModelDelegate {
    let title: String
    let brandName: String
    let imageNames: [String]

    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(
            string: "\(title)",
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .heavy)])
        attributedText.append(NSAttributedString(
            string: "\n\(brandName)",
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)]))
        return CardViewModel(imageNames: imageNames, attributedText: attributedText, textAlignment: .center)
        
    }
}

