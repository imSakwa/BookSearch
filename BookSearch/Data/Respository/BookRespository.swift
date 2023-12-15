//
//  BookRespository.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

import RxSwift

final class BookRespository: BookRespositoryProtocol {
    let storage: BooksResponseStorage
    
    init(storage: BooksResponseStorage) {
        self.storage = storage
    }
}

extension BookRespository {
    /// BookList fetch 메서드
    func fetchBookList(
        query: BookQuery,
        display: Int,
        start: Int,
        sort: BookSort,
        cached: @escaping (BooksPage) -> Void,
        completion: @escaping (Result<BooksPage, Error>) -> Void
    ) {
        let requsetDTO = BookListRequestDTO(query: query.query,
                                            display: display,
                                            start: start,
                                            sort: sort)
        
        let endpoint = APIEndPoint.getBookList(with: requsetDTO)
        let provider = NetworkProvider()
        
        storage.getBookResponse(request: requsetDTO) { result in
            
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
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
    
    func fetchBookList(
        query: BookQuery,
        display: Int,
        start: Int,
        sort: BookSort
    ) -> Observable<Result<BooksPage, Error>> {
        let requsetDTO = BookListRequestDTO(
            query: query.query,
            display: display,
            start: start,
            sort: sort
        )
        
        let endpoint = APIEndPoint.getBookList(with: requsetDTO)
        let provider = NetworkProvider()
        
        
        return storage.getBookResponse(request: requsetDTO)
            .flatMap { result in
                switch result {
                case .success(let responseDTO?):
                    return Observable.create { observer in
                        let result: Result<BooksPage, Error> = .success(responseDTO.toDomain())
                        observer.onNext(result)
                        
                        return Disposables.create()
                    }
                case .failure(_):
                    return provider.request(with: endpoint)
                        .map { response in
                                return .success(response.toDomain())
                        } // Observable<Result>
                default:
                    break
                }
            }
    }
}
