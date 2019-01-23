//
//  CardView.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/27/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit
import SDWebImage

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            // Set default image
            // accessing index 0 will crash if imageNames.count == 0
            let urlString = cardViewModel.imageNames.first ?? ""
            if let url = URL(string: urlString) {
                imageView.sd_setImage(with: url)
            }
            
            // Create bars
            if cardViewModel.imageNames.count != 1 {
                cardViewModel.imageNames.forEach { (_) in
                    let bar = UIView()
                    bar.backgroundColor = deselectedBarColor
                    barsStackView.addArrangedSubview(bar)
                }
                // Set first bar as selected color
                barsStackView.arrangedSubviews[0].backgroundColor = .white
            }
            
            infoLabel.attributedText = cardViewModel.attributedText
            infoLabel.textAlignment = cardViewModel.textAlignment
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver(){
        cardViewModel.imageIndexObserver = { [weak self] (index, imageUrl) in
            print("Getting index number and image from view model")
            if let url = URL(string: imageUrl ?? "") {
                self?.imageView.sd_setImage(with: url)
            }
            
            if let count = self?.cardViewModel.imageNames.count, count > 1 {
                // Set all bars to default color
                self?.barsStackView.arrangedSubviews.forEach { (bar) in
                    bar.backgroundColor = self?.deselectedBarColor
                }
                // Highlight bar from image index
                self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
            }
        }
    }
    
    // Encapsulation
    fileprivate let imageView = UIImageView()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let infoLabel = UILabel()
    fileprivate let barsStackView = UIStackView()
    
    // Configuration
    fileprivate let threshold: CGFloat = 100
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.25)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    fileprivate func setupLayout() {
        // Set round corners
        layer.cornerRadius = 15
        clipsToBounds = true
        
        // Card imageView
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        // Fill the image to its superview.
        imageView.fillSuperview()
        
        // Add gradient
        addGradientLayer()
        
        // Paging bars
        setupPagingBars()
        
        // Info Label properties
        addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
    }
    
    fileprivate func addGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.55,1.1]
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate func setupPagingBars(){
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8), size: CGSize.init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    @objc fileprivate func handlePan(gesture:UIPanGestureRecognizer){
    
        switch gesture.state {
            
        case .began:
            // Remove all animations before adding animations on each cards
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
            
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    @objc fileprivate func handleTap(gesture:UITapGestureRecognizer){
        print("Handling tap and cycling photos")
        let tapLocation = gesture.location(in: nil)
        let shouldAdvancePhotos = tapLocation.x > frame.width/2 ? true : false
        
        if shouldAdvancePhotos {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    fileprivate func handleChanged(_ gesture:UIPanGestureRecognizer){
        let translation = gesture.translation(in: nil)
        
        // Convert radians to degrees
        let degree: CGFloat = translation.x / 10
        let angle = degree * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    fileprivate func handleEnded(_ gesture:UIPanGestureRecognizer) {
        
        // Determine whether gesture is the left or right direction
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1: -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        // Card animation.
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                print("Card dismissed off the screen")
                // Dismiss the card off the screen
                self.frame = CGRect(x: translationDirection * 500, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            // Bring the card back to its origin after removing the card off the screen
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
            //self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.width)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
