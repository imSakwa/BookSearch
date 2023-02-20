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
                 completion: @escaping (Result<BooksPage, Error>) -> Void)
}

final class SearchBookUseCase: SearchBookUseCaseProtocol {
    private let bookRepository: BookRespository

    init(bookRepository: BookRespository) {
        self.bookRepository = bookRepository
    }
    
    func execute(requestValue: SearchBookUseCaseRequestValue,
                 completion: @escaping (Result<BooksPage, Error>) -> Void) {
        
        return bookRepository.fetchBookList(
            query: requestValue.query,
            display: requestValue.display,
            start: requestValue.start,
            sort: requestValue.sort
        ) { result in
            completion(result)
        }
    }
    
}

struct SearchBookUseCaseRequestValue {
    let query: String
    let display: Int
    let start: Int
    let sort: BookSort
    
    init(query: String, start: Int = 1, display: Int = 10, sort: BookSort = .sim) {
        self.query = query
        self.display = display
        self.start = start
        self.sort = sort
    }
}
