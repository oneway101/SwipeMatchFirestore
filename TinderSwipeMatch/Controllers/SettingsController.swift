//
//  SettingsController.swift
//  TinderSwipeMatch
//
//  Created by Ha Na Gill on 1/23/19.
//  Copyright © 2019 com.onewayfirst. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate: class {
    func didSaveSettings()
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: SettingsControllerDelegate?
    
    // instance properties
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    @objc func handleSelectPhoto(button: UIButton){
        print("Selecting photo with button ", button)
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let imageData = image?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to upload image to storeage: ", err)
                return
            }
            print("Finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                hud.dismiss()
                if let err = err {
                    print("Failed to get download URL: ", err)
                    return
                }
                
                let imageUrl =  url?.absoluteString ?? ""
                print("Download url of image is: ", imageUrl)
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = imageUrl
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = imageUrl
                } else {
                    self.user?.imageUrl3 = imageUrl
                }
            })
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView() // removes default seperater lines
        tableView.keyboardDismissMode = .interactive
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser(){
        print("current user uid", Auth.auth().currentUser?.uid)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            print(dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }

    }
    
    fileprivate func loadUserPhotos(){
        guard let imageUrl1 = user?.imageUrl1, let url1 = URL(string: imageUrl1) else { return }
        SDWebImageManager.shared().loadImage(with: url1, options: SDWebImageOptions.continueInBackground, progress: nil) { (image, data, err, _, _, _) in
            self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        guard let imageUrl2 = user?.imageUrl2, let url2 = URL(string: imageUrl2) else { return }
        SDWebImageManager.shared().loadImage(with: url2, options: SDWebImageOptions.continueInBackground, progress: nil) { (image, data, err, _, _, _) in
            self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        guard let imageUrl3 = user?.imageUrl3, let url3 = URL(string: imageUrl3) else { return }
        SDWebImageManager.shared().loadImage(with: url3, options: SDWebImageOptions.continueInBackground, progress: nil) { (image, data, err, _, _, _) in
            self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    lazy var header: UIView = {
        let header = UIView()
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding:.init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        return header
    }()
    
    // Shift label to the right
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return header }
        let label = HeaderLabel()
        
        switch section {
        case 1:
            label.text = "Name"
        case 2:
            label.text = "Profession"
        case 3:
            label.text = "Age"
        case 4:
            label.text = "Bio"
        default:
            label.text = "Seeking Age Range"
            
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 300 : 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Min \(Int(slider.value))"
        user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.maxLabel.text = "Max \(Int(slider.value))"
        user?.maxSeekingAge = Int(slider.value)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            ageRangeCell.minLabel.text = "Min \(user?.minSeekingAge ?? -1)"
            ageRangeCell.maxLabel.text = "Max \(user?.maxSeekingAge ?? -1)"
            return ageRangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)

        switch indexPath.section {
        case 1:
            cell.textfield.placeholder = "Enter Name"
            cell.textfield.text = user?.name
            cell.textfield.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textfield.placeholder = "Enter Profession"
            cell.textfield.text = user?.profession
            cell.textfield.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textfield.placeholder = "Enter Age"
            cell.textfield.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textfield.text = String(age)
            }
        default:
            cell.textfield.placeholder = "Enter Bio"
        }
        
        return cell
    }
    
    @objc fileprivate func handleNameChange(textfield: UITextField){
        user?.name = textfield.text
    }
    
    @objc fileprivate func handleProfessionChange(textfield: UITextField){
        user?.profession = textfield.text
    }
    
    @objc fileprivate func handleAgeChange(textfield: UITextField){
        user?.age = Int(textfield.text ?? "")
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleSave(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String:Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "profession": user?.profession ?? "",
            "age": user?.age ?? -1,
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                print("Failed to save user settings: ", err)
                return
            }
            print("Finished saving user info")
            self.dismiss(animated: true, completion: {
                self.delegate?.didSaveSettings()
            })
        }
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }


}
