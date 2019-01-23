//
//  User.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/28/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit

struct User: CardViewModelDelegate {
    let name: String?
    let age: Int?
    let profession: String?
    let imageUrl1: String?
    let uid: String?
    
    init(dictionary:[String:Any]){
        self.name = dictionary["fullName"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.uid = dictionary["uid"] as? String
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(
            string: "\(name ?? "")",
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : ""
        
        attributedText.append(NSAttributedString(
            string: "  \(ageString)",
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        attributedText.append(NSAttributedString(
            string: "\n\(profession ?? "")",
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)]))
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedText: attributedText, textAlignment: .left)

    }
}

