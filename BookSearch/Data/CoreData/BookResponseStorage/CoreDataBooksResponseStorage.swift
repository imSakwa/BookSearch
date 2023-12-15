//
//  CoreDataBooksResponseStorage.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/23.
//

import Foundation
import CoreData

import RxSwift

final class CoreDataBooksResponseStorage {
    private let storage: CoreDataStorage
    
    init(storage: CoreDataStorage = CoreDataStorage.shared) {
        self.storage = storage
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
    
    func getBookResponse(
        request: BookListRequestDTO
    ) -> Observable<Result<BookListResponseDTO?, Error>> {
        return storage.performBackgroundTask()
            .map { context in
                do {
                    let fetchRequest = BookListRequestEntity.fetchRequest()
                    let requestEntity = try context.fetch(fetchRequest).first
                    
                    return .success(requestEntity?.response?.toDTO())
                    
                } catch {
                    return .failure(error)
                }
            }
    }
    
    func save(response: BookListResponseDTO, request: BookListRequestDTO) {
        storage.performBackgroundTask { context in
            do {
                let fetchRequest = BookListRequestEntity.fetchRequest()
                
                do {
                    if let result = try context.fetch(fetchRequest).first {
                        context.delete(result)
                    }
                } catch {
                    print(error)
                }
                
                let requestEntity = request.toDTO(context: context)
                requestEntity.response = response.toDTO(context: context)
                
                try context.save()
            } catch {
                print("error")
            }
        }
    }
}
