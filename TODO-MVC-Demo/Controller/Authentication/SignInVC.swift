//
//  SignInVC.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceHolders()
        UserDefaultsManager.shared().isLoggedIn = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        return signInVC
    }
    
    
    
    // MARK:- Actions
    @IBAction func signInSubmittBtn(_ sender: UIButton) {
        if isDataEntered(){
            if isValidRegex(){
                signInWithEnteredData()
                
            }
        }
    }
    
    @IBAction func signUpAccountBtn(_ sender: UIButton) {
        goToSignUpVC()
    }
}

// MARK:- Extension Private Methods
extension SignInVC{
    private func setPlaceHolders(){
        userEmailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        userPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    private func isDataEntered()-> Bool{
        guard userEmailTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter Email",actionTitle: "Dismiss")
            return false
        }
        guard userPasswordTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter Password",actionTitle: "Dismiss")
            return false
        }
        
        return true
    }
    
    private func isValidRegex() -> Bool{
        guard isValidEmail(email: userEmailTextField.text) else{
            showAlertWithCancel(alertTitle: "Alert",message: "Please Enter Valid Email",actionTitle: "Dismiss")
            return false
        }
        guard isValidPassword(testStr: userPasswordTextField.text) else{
            showAlertWithCancel(alertTitle: "Alert",message: "Password is Incorect",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
    private func goToTodoListVC(){
        let todoListVC = TodoListVC.create()
        navigationController?.pushViewController(todoListVC, animated: true)
    }
    
    private func goToSignUpVC() {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func signInWithEnteredData(){
        self.view.showLoading()
        
        APIManager.loginAPIRouter(email: userEmailTextField.text!, password: userPasswordTextField.text!){ response in
            switch response{
            case .failure(let error):
                if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                    self.showAlertWithCancel(alertTitle: "Error",message: "Incorrect Email and Password",actionTitle: "Dismiss")
                }else{
                    self.showAlertWithCancel(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
                    print(error.localizedDescription)
                }
            case .success(let result):
                    print(result.token)
                    UserDefaultsManager.shared().token = result.token
                    UserDefaultsManager.shared().userId = result.user.id
                    self.goToTodoListVC()
                }
            self.view.hideLoading()
        }
        
    }
}
