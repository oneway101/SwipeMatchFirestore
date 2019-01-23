//
//  HomeController.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 12/20/18.
//  Copyright © 2018 com.onewayfirst. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]() // empty CardViewModel array.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.profileButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.lastFetchedUser = user
                self.cardViewModels.append(user.toCardViewModel())
                self.setupCardFromUser(user: user)
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView()
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc func handleSettings(){
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    // MARK: - Fileprivate
    
    fileprivate func setupFirestoreUserCards(){
        cardViewModels.forEach { (cardVM) in
            
            let cardView = CardView()
            cardView.cardViewModel = cardVM
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomControls])
        
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
