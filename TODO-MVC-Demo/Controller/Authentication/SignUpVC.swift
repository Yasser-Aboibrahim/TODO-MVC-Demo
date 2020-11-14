//
//  SignUpVC.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userAgeTextField: UITextField!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceHolders()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    
    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        return signUpVC
    }
    
    
    
    // MARK:- Actions
    @IBAction func signUpSubmittBtn(_ sender: UIButton) {
       if isDataEntered(){
            if isValidRegex(){
                signUpWithEnteredData()
            }
        }
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        goToSignInVC()
    }
}
// MARK:- Extension Private Functions
extension SignUpVC{
    
    private func setPlaceHolders(){
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        userEmailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        userPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        userAgeTextField.attributedPlaceholder = NSAttributedString(string: "Age", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    private func isDataEntered()-> Bool{
        guard userNameTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter Name",actionTitle: "Dismiss")
            return false
        }
        guard userEmailTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter email",actionTitle: "Dismiss")
            return false
        }
        guard userPasswordTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter Password",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
    private func isValidRegex() -> Bool{
        guard isValidEmail(email: userEmailTextField.text) else{showAlertWithCancel(alertTitle: "Wrong Email Form",message: "Please Enter Valid email(a@a.com)",actionTitle: "Dismiss")
            return false
        }
        guard isValidPassword(testStr: userPasswordTextField.text) else{
            showAlertWithCancel(alertTitle: "Wrong Password Form",message: "Password need to be : \n at least one uppercase \n at least one digit \n at leat one lowercase \n characters total",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
    private func goToSignInVC() {
        let signInVC = SignInVC.create()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func goToTodoListVC(){
        let todoListVC = TodoListVC.create()
        navigationController?.pushViewController(todoListVC, animated: true)
    }
    
    private func signUpWithEnteredData(){
        self.view.showLoading()
        
        APIManager.registerAPIRouter(email: userEmailTextField.text!, password: userPasswordTextField.text!, name: userNameTextField.text!, age: Int(userAgeTextField.text!)!){ response in
            switch response{
            case .failure(let error):
                if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                    self.showAlertWithCancel(alertTitle: "Error",message: "Incorrect Email and Password",actionTitle: "Dismiss")
                }else{
                    self.showAlertWithCancel(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
                    print(error.localizedDescription)
                }
            case .success(let result):
                print(result)
                print("Sign Up Completed")
            }
            
            self.goToSignInVC()
            self.view.hideLoading()
        }
        
    }
}
