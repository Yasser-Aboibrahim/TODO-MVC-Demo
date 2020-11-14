//
//  TodoListVC.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit

class TodoListVC: UIViewController {
    
    // MARK:- Properties
    var userTasksArr = [TaskData]()
    
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        setableView()
        UserDefaultsManager.shared().isLoggedIn = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserTasks()
        self.tableView.reloadDataWithoutScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserTasks()
        self.tableView.reloadDataWithoutScroll()
    }
    
    // MARK:- Public Methods
    class func create() -> TodoListVC {
        let todoListVC: TodoListVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.todoListVC)
        return todoListVC
    }
    
    
}

// MARK:- Tableview Extension
extension TodoListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userTasksArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.TodoCell, for: indexPath) as? TodoCell else{
            return UITableViewCell()
        }
        cell.configure(task: self.userTasksArr[indexPath.row])
        cell.deleteTaskBtn.tag = indexPath.row
        cell.deleteTaskBtn.addTarget(self, action: #selector(deleteTaskBtnTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func deleteTaskBtnTapped(_ sender: UIButton){
        // use the tag of button as index
        let task = userTasksArr[sender.tag]
        UserDefaultsManager.shared().taskId = task.id!
        let deleteAlert = UIAlertController(title: "Sorry", message: "Are You Sure You Want To Delete This Task?", preferredStyle: .alert)
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            APIManager.deleteTaskAPIRouter{ (response) in
                switch response{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let result):
                    print("The task is deleted ")
                    print(result)
                    
                    
                }
                DispatchQueue.main.async {
                    self.getUserTasks()
                    self.tableView.reloadData()
                    self.tableView.reloadDataWithoutScroll()
                }

                
            }
            
//            APIManager.deleteTask(taskId: task.id!) { error in
//                if error != nil {
//                    print(error!.localizedDescription)
//                } else {
//                    print("The task is deleted")
//
//                }
//                DispatchQueue.main.async {
//                    self.getUserTasks()
//                    self.tableView.reloadData()
//                    self.tableView.reloadDataWithoutScroll()
//                }
//
//            }
        }))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
}

// MARK:- Extension reload Tableview Without Scroll
extension UITableView {
    
    func reloadDataWithoutScroll() {
        let offset = contentOffset
        reloadData()
        layoutIfNeeded()
        setContentOffset(offset, animated: false)
    }
}

// MARK:- Extension Private Methods
extension TodoListVC{
    private func setableView(){
        tableView.register(UINib(nibName: Cells.TodoCell, bundle: nil), forCellReuseIdentifier: Cells.TodoCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setNavbar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile" , style: .plain, target: self, action:  #selector(tapLeftBtn))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(tapRightBtn))
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 25.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white],for: .normal)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                              NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    @objc private func tapLeftBtn(){
        goToProfileVC()
    }
    
    @objc private func tapRightBtn(){
        addTaskBtn()
        
    }
    
    private func addTaskBtn(){
        let alertController = UIAlertController(title: "Add Task", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Task"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let taskTextField = alertController.textFields![0] as UITextField
            if let taskTF = taskTextField.text{
                self.view.showLoading()
                APIManager.addTaskAPIRouter(description: taskTF){ (response) in
                    switch response{
                    case .failure(let error):
                        self.showAlertWithCancel(alertTitle: "Error",message: "\(error.localizedDescription)",actionTitle: "Dismiss")
                    case .success(let result):
                        print(result)
                        self.getUserTasks()
                        }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.reloadDataWithoutScroll()
                    }
                    self.view.hideLoading()
                    
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
    
    private func goToProfileVC() {
        let profileVC = ProfileVC.create()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func getUserTasks(){
        self.view.showLoading()
        
        APIManager.getUserTasksAPIRouter{ (response) in
            switch response{
            case .failure(let error):
                if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                    self.showAlertWithCancel(alertTitle: "Error",message: "Incorrect Email and Password",actionTitle: "Dismiss")
                }else{
                    self.showAlertWithCancel(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
                    print(error.localizedDescription)
                }
            case .success(let result):
                if let taskArr = result?.data{
                    if taskArr.isEmpty{
                        self.userTasksArr = []
                    }else{
                        self.userTasksArr = taskArr
                    }
            }
            self.view.hideLoading()
            self.tableView.reloadDataWithoutScroll()
            }
            
        }
    }
}

