//
//  TodoCell.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/30/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    /// MARK:- Outlets
    @IBOutlet weak var taskLable: UILabel!
    @IBOutlet weak var deleteTaskBtn: UIButton!
    
    // MARK:- Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK:- Public Methods
    func configure(task: TaskData){
            taskLable.text = task.description
    
    }
}

