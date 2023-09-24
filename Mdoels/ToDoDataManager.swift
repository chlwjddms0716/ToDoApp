//
//  ToDoDataManager.swift
//  ToDoApp
//
//  Created by 최정은 on 2023/09/23.
//

import Foundation
import UIKit
import CoreData

final class ToDoDataManager{
    
    static let shared = ToDoDataManager()
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "ToDoData"
    
    func getToDoDataList() -> [ToDoData] {
        var toDoList: [ToDoData] = []
        
        if let context = context {
            
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            
            request.sortDescriptors = [dateOrder]
            
            do{
                if let fetchedToDoList = try context.fetch(request) as? [ToDoData] {
                    toDoList = fetchedToDoList
                }
            }catch{
                print("가져오는 것 실패")
            }
        }
        
        return toDoList
    }
    
    func deleteToDoData(data: ToDoData, completion: @escaping () -> Void){
        
        guard let date = data.date else {
            completion()
            return
        }
        
        if let context = context {
            
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [ToDoData] {
                    
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetToDo = fetchedToDoList.first {
                        context.delete(targetToDo)
                        
                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
    
    func insertToDoData(toDoText: String?, colorInt: Int64, completion: @escaping () -> Void){
        
        if let context = context {
            
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                if let toDoData = NSManagedObject(entity: entity, insertInto: context) as? ToDoData {
                    
                    toDoData.memoText = toDoText
                    toDoData.date = Date()
                    toDoData.color = colorInt
                    
                    //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        
        completion()
    }
    
    func updateToDoData(newToDoData: ToDoData, completion: @escaping () -> Void){
        
        guard let date = newToDoData.date else {
            completion()
            return
        }
        
        if let context = context{
            
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedToDoList = try context.fetch(request) as? [ToDoData] {
                    // 배열의 첫번째
                    if var targetToDo = fetchedToDoList.first {
                        
                        // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                        targetToDo = newToDoData
                        
                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("업데이트 실패")
                completion()
            }
        }
        
    }
}
