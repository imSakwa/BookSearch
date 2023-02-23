//
//  CoreDataBooksResponseStorage.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/23.
//

import Foundation
import CoreData

final class CoreDataBooksResponseStorage {
    private let storage: CoreDataStorage
    
    init(storage: CoreDataStorage = CoreDataStorage.shared) {
        self.storage = storage
    }
    
    private func fetchRequest() {
        
    }
   
}

extension CoreDataBooksResponseStorage: BooksResponseStorage {
    func getBookResponse(
        request: BookListRequestDTO,
        completion: @escaping (Result<BookListResponseDTO?, Error>) -> Void
    ) {
        storage.performBackgroundTask { context in
            do {
                let fetchRequest = BookListRequestEntity.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest).first
                
                completion(.success((requestEntity?.response?.toDTO())))
            } catch {
                completion(.failure(Error.self as! Error))
            }
        }
    }
}
