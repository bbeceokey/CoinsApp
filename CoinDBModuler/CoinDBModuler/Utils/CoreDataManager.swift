//
//  CoreDataManager.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 9.05.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoinDBModuler")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("core data ya eklendi")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [CoinIcons]? {
        let context = persistentContainer.viewContext
           let fetchRequest: NSFetchRequest<CoinIcons> = CoinIcons.fetchRequest()
           do {
               let data = try context.fetch(fetchRequest)
               return data
           } catch {
               print("Error fetching data: \(error.localizedDescription)")
               return nil
           }
    }
}
