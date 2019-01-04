//
//  HomeBottomControlsStackView.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/26/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    // override initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let subviews = [UIImage(named: "refresh-circle"), UIImage(named: "dismiss-circle"), UIImage(named: "star-circle"), UIImage(named: "heart-circle"), UIImage(named: "boost-circle")].map { (img) -> UIView in
            
            let button = UIButton(type: .system)
            button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        // Add subviews
        subviews.forEach { (view) in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
