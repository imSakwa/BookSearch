//
//  CoreDataBookQueryStorage.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import Foundation
import CoreData

final class CoreDataBookQueryStorage: BookQueryStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataBookQueryStorage {
    func fetchRecentQueries(
        maxCount: Int,
        completion: @escaping (Result<[BookQuery], Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request = BookQueryEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(BookQueryEntity.createdAt), ascending: false)]
                request.fetchLimit = 10
                let result = try context.fetch(request).map { $0.toDomain() }
                
                completion(.success(result))
            } catch {
                completion(.failure(Error.self as! Error))
            }
        }
    }
    
    func saveRecentQuery(
        query: BookQuery,
        completion: @escaping (Result<BookQuery, Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let entity = BookQueryEntity(query: query, insertInto: context)
                try context.save()
                
                completion(.success(entity.toDomain()))
            } catch {
                completion(.failure(Error.self as! Error))
            }
        }
    }
}
