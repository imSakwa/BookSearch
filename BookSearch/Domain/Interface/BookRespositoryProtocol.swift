//
//  BookRespositoryProtocol.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

protocol BookRespositoryProtocol {
    /// 책 리스트 가져오기
    func fetchBookList(
        query: String,
        display: Int,
        start: Int,
        sort: BookSort,
        cached: @escaping (BooksPage) -> Void,
        completion: @escaping (Result<BooksPage, Error>) -> Void
    )
}
