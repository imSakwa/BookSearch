//
//  BooksResponseStorage.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/23.
//

import Foundation

protocol BooksResponseStorage {
    func getBookResponse(request: BookListRequestDTO, completion: @escaping (Result<BookListResponseDTO?, Error>) -> Void)
    func save(response: BookListResponseDTO, request: BookListRequestDTO)
}
