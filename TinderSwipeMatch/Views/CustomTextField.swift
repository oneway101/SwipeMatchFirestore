//
//  CustomTextField.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/4/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding: CGFloat
    
    init(padding: CGFloat, cornerRadius: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        backgroundColor = .white
    }
    
    // Sets the height of the textfield
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 44)
    }
    
    // Padding of placeholder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    // Padding of typing text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
