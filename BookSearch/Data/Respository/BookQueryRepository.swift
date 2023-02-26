//
//  BookQueryRepository.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import Foundation

final class BookQueryRepository: BookQueryRepositoryProtocol {
    let storage: BookQueryStorage
    
    init(storage: BookQueryStorage) {
        self.storage = storage
    }
}

extension BookQueryRepository {
    func fetchRecentQueries(
        maxCount: Int,
        completion: @escaping (Result<[BookQuery], Error>) -> Void
    ) {
        return storage.fetchRecentQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(
        query: BookQuery,
        completion: @escaping (Result<BookQuery, Error>) -> Void
    ) {
        return storage.saveRecentQuery(query: query, completion: completion)
    }
}
