//
//  RegistrationViewModel.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/8/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    // Reactive Programming
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var fullName: String? { didSet {checkFormValidity()} }
    var email: String? { didSet {checkFormValidity()} }
    var password: String? { didSet {checkFormValidity()} }
    
    func performRegistration(completion:@escaping (Error?) -> Void){
        
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err {
                completion(err)
                return
            }
            
            print("Successfully created a user: ", result?.user.uid ?? "")
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveImageToFirebase(completion:@escaping (Error?) -> Void) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            print("Finished uploading image to storage")
            
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                
                let imageUrl =  url?.absoluteString ?? ""
                print("Download url of image is: ", imageUrl)
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
            
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> Void) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl1": imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }

}
