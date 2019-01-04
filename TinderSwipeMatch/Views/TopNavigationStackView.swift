//
//  TopNavigationStackView.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/26/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let profileButton = UIButton(type: .system)
    let chatButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: UIImage(named: "fire-icon"))
    
    // override initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        profileButton.setImage(UIImage(named: "profile-icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        chatButton.setImage(UIImage(named: "chat-icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        fireImageView.contentMode = .scaleAspectFit
        
        let subviews = [profileButton, fireImageView, chatButton]
        
        // Add subviews
        subviews.forEach { (view) in
            addArrangedSubview(view)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
