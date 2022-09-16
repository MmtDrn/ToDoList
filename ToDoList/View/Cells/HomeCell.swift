//
//  HomeCell.swift
//  ToDoList
//
//  Created by MacBook on 15.07.2022.
//

import UIKit

protocol PCompletedTodo{
    func completed(index:Int)
}

class HomeCell: UITableViewCell {

    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    
    var pCompleted:PCompletedTodo?
    var index:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func checkButton(_ sender: Any) {
        
        pCompleted?.completed(index: index!)
    }
    
    func setupView(toDo:ToDoModel) {
        self.titleLabel.text = toDo.title?.capitalized
        self.descriptionLabel.text = toDo.desc
        self.categoryLabel.text = toDo.category
        self.alarmLabel.text = toDo.date
    }
    func setupCompleted(){
        
        self.buttonOutlet.tintColor = .systemGreen
        self.titleLabel.textColor = .systemGray4
        self.descriptionLabel.textColor = .systemGray4
        self.categoryLabel.textColor = .systemGray4
        self.categoryLabel.layer.borderColor = UIColor.systemGray4.cgColor
        self.alarmLabel.textColor = .systemGray4
        self.alarmLabel.layer.borderColor = UIColor.systemGray4.cgColor
    }
    func setupNotCompleted(){
        
        self.buttonOutlet.tintColor = .systemGray4
        self.titleLabel.textColor = .label
        self.descriptionLabel.textColor = .label
        self.categoryLabel.textColor = .systemBlue
        self.categoryLabel.layer.borderColor = UIColor.label.cgColor
        self.alarmLabel.textColor = .systemRed
        self.alarmLabel.layer.borderColor = UIColor.label.cgColor
    }
}
