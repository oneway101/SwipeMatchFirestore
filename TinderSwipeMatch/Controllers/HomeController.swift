//
//  HomeController.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/20/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.profileButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    
        setupLayout()
        setupDummyCards()
    }
    
    @objc func handleSettings(){
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    let cardViewModels: [CardViewModel] = {
        
        let cards = [
            Card(name: "Greek Salad", calorie: 350, imageNames: ["greek-salad"]),
            Card(name: "Apple Pie", calorie: 150, imageNames: ["apple-pie"]),
            Advertiser(title: "Penthouse 808", brandName: "Crowning The Ravel Hotel is Penthouse 808, a 9,500 square-foot indoor/outdoor rooftop restaurant, lounge and events space that offers breathtaking views of the Manhattan skyline and Queensboro bridge.", imageNames: ["penthouse808"]),
            Advertiser(title: "Gallow Green", brandName: "The verdant, vintage train station-inspired rooftop bar at the McKittrick Hotel. affords a regal view of gleaming West Side buildings and the cloud-streaked horizon.", imageNames: ["gallow-green"]),
            Card(name: "Chocolate Cake", calorie: 352, imageNames: ["choco-cake-1","choco-cake-2","choco-cake-3"])
            ] as [CardViewModelDelegate]
        
        let viewModels = cards.map({return $0.toCardViewModel()})
        return viewModels
    }()
        
    
    // MARK: - Fileprivate
    
    fileprivate func setupDummyCards(){
        cardViewModels.forEach { (cardVM) in
            
            let cardView = CardView()
            cardView.cardViewModel = cardVM
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomStackView])
        
        // Set the stackview properties
        overallStackView.axis = .vertical
        
        // Add the stackView into the view
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        overallStackView.bringSubviewToFront(cardDeckView)
    }
}
