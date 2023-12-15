//
//  BooksResponseStorage.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/23.
//

import Foundation

import RxSwift

protocol BooksResponseStorage {
    func getBookResponse(
        request: BookListRequestDTO,
        completion: @escaping (Result<BookListResponseDTO?, Error>) -> Void
    )
    
    func getBookResponse(
        request: BookListRequestDTO
    ) -> Observable<Result<BookListResponseDTO?, Error>>
    
    func save(response: BookListResponseDTO, request: BookListRequestDTO)
}
