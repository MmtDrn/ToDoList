//
//  DataManagers.swift
//  ToDoList
//
//  Created by MacBook on 18.07.2022.
//

import Foundation
import UIKit
import CoreData

enum IndexToDo:Int {
    
    case All = 0
    case Shopping = 1
    case Work = 2
    case Personal = 3
    case ILikeIt = 4
    
    var query:String {
        
        switch self {
        case .All:
            return "All"
        case .Shopping:
            return "Shopping"
        case .Work:
            return "Work"
        case .Personal:
            return "Personal"
        case .ILikeIt:
            return "I like it!"
        }
    }
}

class DataManagers {
    
    static func getAllData(tableView:UITableView, context:NSManagedObjectContext,completion: @escaping ([ToDoModel]) -> ()) {
        
        DispatchQueue.main.async {
            do {
                let toDo = try? context.fetch(ToDoModel.fetchRequest())
                
                if let toDo = toDo {
                    completion(toDo)
                }
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getCategoryData(query:String,tableView:UITableView, context:NSManagedObjectContext,completion: @escaping ([ToDoModel]) -> ()) {
        
        DispatchQueue.main.async {
            
            let fetchrequest:NSFetchRequest<ToDoModel> = ToDoModel.fetchRequest()
            
            fetchrequest.predicate = NSPredicate(format: "category == %@", query)
            
            do {
                let toDo = try? context.fetch(fetchrequest)
                
                if let toDo = toDo {
                    completion(toDo)
                }
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
