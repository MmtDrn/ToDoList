//
//  AddToDoVC.swift
//  ToDoList
//
//  Created by MacBook on 16.07.2022.
//

import UIKit

final class AddToDoVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    private var datePicker:UIDatePicker?
    private var pickerView:UIPickerView?
    private var categorys = ["Shopping", "Work", "Personal", "I like it!"]
    private let context = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configViews()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if let title = titleTextField.text, let description = descriptionTextField.text, let category = categoryTextField.text, let date = dateTextField.text {
            
            let toDo = ToDoModel(context: self.context)
            toDo.title = title
            toDo.desc = description
            toDo.category = category
            toDo.date = date
            toDo.completed = false
            
            appDelegate.saveContext()
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK - View Config
extension AddToDoVC {
    private func configViews() {
        
        makeDatePicker()
        makeCategoryPicker()
        
        let touchSensation = UITapGestureRecognizer(target: self, action: #selector(self.touchSensation))
        view.addGestureRecognizer(touchSensation)
        navigationItem.rightBarButtonItem?.tintColor = .systemGreen
    }
    
    private func makeDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
        }
        
        let toolbar = UIToolbar()
        toolbar.tintColor = UIColor.red
        toolbar.sizeToFit()
        
        let okeyButton = UIBarButtonItem(title: "Okey", style: .done, target: self, action: #selector(self.okey))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel))
        
        toolbar.setItems([cancelButton,spaceButton,okeyButton], animated: true)
        self.dateTextField.inputAccessoryView = toolbar
        
        datePicker?.addTarget(self, action: #selector(self.showDate(datepickers:)), for: .valueChanged)
    }
    
    private func makeCategoryPicker() {
        pickerView = UIPickerView()
        pickerView?.dataSource = self
        pickerView?.delegate = self
        
        categoryTextField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.tintColor = UIColor.red
        toolbar.sizeToFit()
        
        let okeyButton = UIBarButtonItem(title: "Okey", style: .done, target: self, action: #selector(self.okey))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel))
        
        toolbar.setItems([cancelButton,spaceButton,okeyButton], animated: true)
        self.categoryTextField.inputAccessoryView = toolbar
    }   
}

// MARK - Funcs
extension AddToDoVC {
   
    @objc private func showDate(datepickers:UIDatePicker) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let date = dateFormat.string(from: datepickers.date)
        
        dateTextField.text = date
    }
    
    @objc private func touchSensation () {
        view.endEditing(true)
    }
    
    @objc func okey() {
        view.endEditing(true)
    }
    @objc func cancel() {
        view.endEditing(true)
    }
}

// MARK - Category PickerView
extension AddToDoVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorys.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorys[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categorys[row]
    }
}
