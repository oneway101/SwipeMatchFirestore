//
//  HomeBottomControlsStackView.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/26/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh-circle"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss-circle"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "star-circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "heart-circle"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "boost-circle"))
    
    // override initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Add subviews
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { (view) in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
