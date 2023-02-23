//
//  BookRespository.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

final class BookRespository: BookRespositoryInterface {
    
    let storage: CoreDataBooksResponseStorage
    
    init(storage: CoreDataBooksResponseStorage) {
        self.storage = storage
    }
}

extension BookRespository {
    /// BookList fetch 메서드
    func fetchBookList(
        query: String,
        display: Int,
        start: Int,
        sort: BookSort,
        cached: @escaping (BooksPage) -> Void,
        completion: @escaping (Result<BooksPage, Error>) -> Void
    ) {
        let requsetDTO = BookListRequestDTO(query: query,
                                            display: display,
                                            start: start,
                                            sort: sort)
        
        let endpoint = APIEndPoint.getBookList(with: requsetDTO)
        let provider = NetworkProvider()
        
        storage.getBookResponse(request: requsetDTO) { result in
            
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
                return
            }
            
            provider.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.storage.save(response: responseDTO, request: requsetDTO)
                    completion(.success(responseDTO.toDomain()))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
