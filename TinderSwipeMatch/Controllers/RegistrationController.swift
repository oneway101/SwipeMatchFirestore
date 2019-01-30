//
//  RegistrationController.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/4/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        // Dismiss the picker after selecting the photo
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
}

class RegistrationController: UIViewController {
    
    // UI Components
    
    let profilePhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.black, for: .normal)
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 15, cornerRadius: 10)
        tf.placeholder = "Full Name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
        
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 15, cornerRadius: 10)
        tf.placeholder = "Email Address"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordField: CustomTextField = {
        let tf = CustomTextField(padding: 15, cornerRadius: 10)
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .disabled)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModalObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Fileprivate
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc func handleRegister() {
        print("Register button tapped")
        self.dismissKeyboard()
        registrationViewModel.performRegistration { [unowned self] (err) in
            if let err = err {
                self.showHUDWithError(error: err)
                return
            }
            print("Finished registering a new user")
            self.dismiss(animated: true)
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3)
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModalObserver(){
        // Form Validation Observer
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            print("isFormValid: ", isFormValid)
            if isFormValid {
                self.registerButton.isEnabled = true
                self.registerButton.backgroundColor = UIColor.rgb(red: 200, green: 70, blue: 70)
            } else {
                self.registerButton.isEnabled = false
                self.registerButton.backgroundColor = .lightGray
            }
        }
        // Image Observer
        registrationViewModel.bindableImage.bind { [unowned self] (image) in
            self.profilePhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        // Registering Observer
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Registering"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    @objc fileprivate func handleTextChange(textfield: UITextField){
        if textfield == fullNameTextField {
            registrationViewModel.fullName = textfield.text
        } else if textfield == emailTextField {
            registrationViewModel.email = textfield.text
        } else {
            registrationViewModel.password = textfield.text
        }
    }
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc fileprivate func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        print("Keyboard will show")
        
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let translateY = keyboardFrame.height - bottomSpace + 8
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -translateY)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        print("Keyboard will hide")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    lazy var stackView = UIStackView.init(arrangedSubviews: [
        profilePhotoButton,
        fullNameTextField,
        emailTextField,
        passwordField,
        registerButton
        ])
    
    fileprivate func setupLayout() {
       
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer(){
    
        let electricPink = UIColor.rgb(red: 253, green: 41, blue: 123)
        let fieryRose = UIColor.rgb(red: 255, green: 88, blue: 100)
        let pastelRed = UIColor.rgb(red: 255, green: 101, blue: 91)
    
        gradientLayer.colors = [pastelRed.cgColor, fieryRose.cgColor, electricPink.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
    }
}
