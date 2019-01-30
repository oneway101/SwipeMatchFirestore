//
//  AgeRangeCell.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/29/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let minLabel: UILabel = {
        let label = ageRangeLabel()
        label.text = "Min 18"
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = ageRangeLabel()
        label.text = "Max 100"
        return label
    }()
    
    class ageRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let ageRangeStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel,minSlider]),
            UIStackView(arrangedSubviews: [maxLabel,maxSlider])
        ])
        ageRangeStackView.axis = .vertical
        ageRangeStackView.spacing = 16
        addSubview(ageRangeStackView)
        ageRangeStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
