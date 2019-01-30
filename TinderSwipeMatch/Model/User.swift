//
//  User.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/28/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit

struct User: CardViewModelDelegate {
    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    init(dictionary:[String:Any]){
        self.uid = dictionary["uid"] as? String
        self.name = dictionary["fullName"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        
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
        
        var imageUrls = [String]() // empty string array
        // Append image urls if it is not nil
        if let url = imageUrl1 { imageUrls.append(url) }
        if let url = imageUrl2 { imageUrls.append(url) }
        if let url = imageUrl3 { imageUrls.append(url) }
        
        return CardViewModel(imageNames: imageUrls, attributedText: attributedText, textAlignment: .left)
        
    }
}
