//
//  SearchBookUseCase.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

protocol SearchBookUseCaseProtocol {
    /// 책 검색 유스케이스
    func execute(requestValue: SearchBookUseCaseRequestValue,
                 cached: @escaping (BooksPage) -> Void,
                 completion: @escaping (Result<BooksPage, Error>) -> Void)
}

final class SearchBookUseCase: SearchBookUseCaseProtocol {
    private let bookRepository: BookRespositoryProtocol
    private let bookQueryRepository: BookQueryRepositoryProtocol

    init(bookRepository: BookRespositoryProtocol, bookQueryRepository: BookQueryRepositoryProtocol) {
        self.bookRepository = bookRepository
        self.bookQueryRepository = bookQueryRepository
    }
    
    func execute(requestValue: SearchBookUseCaseRequestValue,
                 cached: @escaping (BooksPage) -> Void,
                 completion: @escaping (Result<BooksPage, Error>) -> Void) {
        
        return bookRepository.fetchBookList(
            query: requestValue.query,
            display: requestValue.display,
            start: requestValue.start,
            sort: requestValue.sort,
            cached: cached
        ) { result in
            if case .success = result {
                self.bookQueryRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }
            completion(result)
        }
    }
    
}

struct SearchBookUseCaseRequestValue {
    let query: BookQuery
    let display: Int
    let start: Int
    let sort: BookSort
    
    init(query: BookQuery, start: Int = 1, display: Int = 10, sort: BookSort = .sim) {
        self.query = query
        self.display = display
        self.start = start
        self.sort = sort
    }
}
