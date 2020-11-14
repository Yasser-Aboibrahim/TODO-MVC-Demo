//
//  ProfileVC.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/31/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileVC: UITableViewController {

    // MARK:- Properties
    var userData: UserData?
    let imagepicker = UIImagePickerController()
    
    // MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameWithNoImage: UILabel!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        imagepicker.delegate = self
        getUserData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserImage()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setUserData()
       
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.profileVC)
        return profileVC
    }
    
    
    // MARK:- Actions
    @IBAction func logOutBtn(_ sender: UIButton) {
        logOut()
    }
    
    @IBAction func updateUserDataBtnTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Update Age", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "New Age"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let taskTextField = alertController.textFields![0] as UITextField
            if let taskTF = Int(taskTextField.text ?? ""){
                self.view.showLoading()
                
                APIManager.updateUserDataAPIRouter(age: taskTF){ response in
                    switch response{
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let result):
                        print(result)
                        
                    }
                    DispatchQueue.main.async {
                        self.getUserData()
                        self.view.hideLoading()
                    }
                }
                
            }else{
                self.showAlertWithCancel(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}

// MARK:- Extension Image Picker
extension ProfileVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            uploadUserImage(image: pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
       
    }
    
}

// MARK:- Extension Private Methods
extension ProfileVC{
    private func goToSignInVC() {
        let signInVC = SignInVC.create()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func setNavbar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload Photo", style: .plain, target: self, action: #selector(tapRightBtn))
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 15.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white],for: .normal)
    }
    
    @objc private func tapRightBtn(){
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        present(imagepicker, animated: true, completion: nil)
        
    }
    
    private func uploadUserImage(image: UIImage){
        
        self.view.showLoading()
        APIManager.uploadUserImage(userImage: image){ error in
            if error != nil {
                self.showAlertWithCancel(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
            } else {
                print("Uploading photo is Completed")
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk()
            }
            DispatchQueue.main.async {
                self.getUserImage()
                self.view.hideLoading()
            }
            
        }
    }
    
    
    private func getUserImage(){
        
        let userId = UserDefaultsManager.shared().userId
        let imageURL = URLs.base + "/user/\(userId ?? "")/avatar"
        userImageView.sd_setImage(with: URL(string: imageURL))
    }
    
    private func userNameInitials(){
        if let stringInput = userData?.name {
            let initials = stringInput.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
            userNameWithNoImage.text = initials
        }else{
            userNameWithNoImage.text = ""
        }
        
        
    }
    
    
    private func getUserData(){
        self.view.showLoading()
        
        APIManager.getUserDataAPIRouter{ (response) in
            switch response{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let result):
                self.userData = result
                
                print(result)
                self.setUserData()
            }
            DispatchQueue.main.async {
                
                self.getUserImage()
                self.userNameInitials()
                self.view.hideLoading()
            }
            
        }
    }
    
    private func setUserData(){
        nameLabel.text = userData?.name
        emailLabel.text = userData?.email
        ageLabel.text = "\(userData?.age ?? 0)"
        
    }
    
    private func logOut(){
        self.view.showLoading()
        
        APIManager.logOutUserAPIRouter{ (response) in
            switch response{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let result):
                print(result)
                print("Log Out Completed")
            }
            DispatchQueue.main.async {
                self.view.hideLoading()
                UserDefaultsManager.shared().token?.removeAll()
                self.goToSignInVC()
            }
        }
    }

}
