//
//  ViewController.swift
//  ToDoList
//
//  Created by MacBook on 15.07.2022.
//

import UIKit
import UserNotifications

final class HomeVC: UIViewController {
    
    //MARK - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private let context = appDelegate.persistentContainer.viewContext
    private var toDo = [ToDoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filtreToDo()
    }
    
    @IBAction func segmentAction(_ sender: Any) {
        filtreToDo()
    }
}

//MARK - TableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toDo = toDo[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
        
        cell.setupView(toDo: toDo)
        cell.pCompleted = self
        cell.index = indexPath.row
        
        if toDo.completed {
            cell.setupCompleted()
        }else{
            cell.setupNotCompleted()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let toDo = toDo[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [self]
            (contextualAction, view, boolValue) in
            
            self.context.delete(toDo)
            appDelegate.saveContext()
            
            filtreToDo()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK - Funcs
extension HomeVC:PCompletedTodo {
    
    func completed(index: Int) {
        
        let todo = toDo[index]
        
        if todo.completed {
            todo.completed = false
        }else {
            todo.completed = true
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filtreToDo() {
        
        let index = segmentedControl.selectedSegmentIndex
        
        switch index {
            
        case IndexToDo.All.rawValue:
            self.getData()
        case IndexToDo.Shopping.rawValue:
            self.configCategoryData(query: IndexToDo.Shopping.query)
        case IndexToDo.Work.rawValue:
            self.configCategoryData(query: IndexToDo.Work.query)
        case IndexToDo.Personal.rawValue:
            self.configCategoryData(query: IndexToDo.Personal.query)
        case IndexToDo.ILikeIt.rawValue:
            self.configCategoryData(query: IndexToDo.ILikeIt.query)
        default:
            print("nil")
        }
    }
    
    private func getData() {
        DataManagers.getAllData(tableView: self.tableView, context: self.context) { [weak self] toDo in
            
            guard let self = self else { return }
            self.toDo = toDo
        }
    }
    
    private func configCategoryData(query:String) {
        DataManagers.getCategoryData(query: query, tableView: self.tableView, context: self.context) { [weak self] toDo in
            
            guard let self = self else { return }
            self.toDo = toDo
        }
    }
}

//MARK - Configiration
extension HomeVC {
    
    private func configView() {
        getData()
        navigationController?.navigationBar.tintColor = .label
    }
}
