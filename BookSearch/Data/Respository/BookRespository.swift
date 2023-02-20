//
//  BookRespository.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

final class BookRespository: BookRespositoryInterface {
    /// BookList fetch 메서드
    func fetchBookList(
        query: String,
        display: Int,
        start: Int,
        sort: BookSort,
        completion: @escaping (Result<BooksPage, Error>) -> Void
    ) {
        let requsetDTO = BookListRequestDTO(query: query,
                                            display: display,
                                            start: start,
                                            sort: sort)
        
        let endpoint = APIEndPoint.getBookList(with: requsetDTO)
        let provider = NetworkProvider()
        
        provider.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
                
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}
