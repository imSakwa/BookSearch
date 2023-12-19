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
    private let disposeBag = DisposeBag()
    
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
        let requestDTO = BookListRequestDTO(
            query: query.query,
            display: display,
            start: start,
            sort: sort
        )
        
        let endpoint = APIEndPoint.getBookList(with: requestDTO)
        let provider = NetworkProvider()
        
        return Observable.create { observer in
            self.storage.getBookResponse(request: requestDTO)
                .subscribe(onNext: { result in
                    switch result {
                    case .success(let responseDTO):
                        observer.onNext(.success(responseDTO.toDomain()))
                        observer.onCompleted()
                        
                    case .failure(_):
                        provider.request(with: endpoint)
                            .subscribe(onNext: { response in
                                let temp: BooksPage = response.toDomain()
                                observer.onNext(.success(temp))
                                observer.onCompleted()
                            }, onError: { error in
                                observer.onNext(.failure(error))
                            })
                            .disposed(by: self.disposeBag)
                    }
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
            
        }
    }
}
