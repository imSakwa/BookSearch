//
//  CoreDataStorage.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/23.
//

import CoreData

import RxSwift

final class CoreDataStorage {
    static let shared = CoreDataStorage()
    
    private init() { }
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookSearch")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func performBackgroundTask(task: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(task)
    }
    
    func performBackgroundTask() -> Observable<NSManagedObjectContext> {
        return Observable.create { observer in
            self.persistentContainer.performBackgroundTask { backgroundContext in
                if backgroundContext.hasChanges {
                    do {
                        try backgroundContext.save()
                        observer.onNext(backgroundContext)
                        observer.onCompleted()
                        
                    } catch {
                        observer.onError(error)
                    }
                } else {
                    observer.onNext(backgroundContext)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
