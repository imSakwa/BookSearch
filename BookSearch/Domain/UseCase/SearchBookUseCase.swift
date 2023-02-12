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
    let display: Int = 10
    let start: Int = 1
    let sort: BookSort = .sim
}
