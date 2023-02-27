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
                request.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(BookQueryEntity.createdAt), ascending: false)
                ]
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
                try self.removeDuplicate(query: query, context: context)
                try self.removeOldestQuery(query: query, context: context)
                let entity = BookQueryEntity(query: query, insertInto: context)
                try context.save()
                
                completion(.success(entity.toDomain()))
            } catch {
                completion(.failure(Error.self as! Error))
            }
        }
    }
    
    /// 중복 query 제거
    private func removeDuplicate(query: BookQuery, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest = BookQueryEntity.fetchRequest()
        var result = try context.fetch(request)
        
        result.filter { $0.query == query.query }
            .forEach { context.delete($0) }
        result.removeAll { $0.query == query.query }
    }
    
    /// 최대 10개 저장해서 오래된 query 제거
    private func removeOldestQuery(query: BookQuery, context: NSManagedObjectContext) throws {
        let request: NSFetchRequest = BookQueryEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        let result = try context.fetch(request)

        guard result.count > 9 else { return }
        result.suffix(result.count - 9)
            .forEach { context.delete($0) }

    }
}
