//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by 최정은 on 2023/09/23.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
   
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var updateButtonTapped: (ToDoTableViewCell) -> Void = { (sender) in }
    
    var toDoData: ToDoData? {
        didSet{
            setupDatas()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI(){
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 8
        
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 10
    }

    func setupDatas(){
        
        if let toDoData = toDoData {
            
            backView.backgroundColor = MyColor(rawValue: toDoData.color)?.backgoundColor
            toDoTextLabel.text = toDoData.memoText
            dateLabel.text = toDoData.dateString
            
            updateButton.backgroundColor = MyColor(rawValue: toDoData.color)?.buttonColor
        }
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        
        updateButtonTapped(self)
    }
}
