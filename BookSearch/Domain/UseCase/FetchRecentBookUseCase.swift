//
//  FetchRecentBookQueryUseCase.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import Foundation

final class FetchRecentBookQueryUseCase {
    struct FetchQueryRequestValue {
        let maxCount: Int
    }

    // MARK: Property
    typealias ResultValue = (Result<[BookQuery], Error>)
    private let requestValue: FetchQueryRequestValue
    private let bookQueryRepository: BookQueryRepositoryProtocol
    private let completion: (ResultValue) -> Void
    
    // MARK: Life Cycle
    init(
        requestValue: FetchQueryRequestValue,
        repository: BookQueryRepositoryProtocol,
        completion: @escaping (ResultValue) -> Void
    ) {
        self.requestValue = requestValue
        bookQueryRepository = repository
        self.completion = completion
    }
}

// MARK: - Functions
extension FetchRecentBookQueryUseCase {
    func fetchQuery() {
        bookQueryRepository.fetchRecentQueries(
            maxCount: requestValue.maxCount,
            completion: completion
        )
    }
}
