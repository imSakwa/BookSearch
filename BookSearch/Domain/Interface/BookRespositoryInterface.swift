//
//  BookRespositoryInterface.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

protocol BookRespositoryInterface {
    /// 책 리스트 가져오기
    func fetchBookList(
        query: String,
        display: Int,
        start: Int,
        sort: BookSort,
        completion: @escaping (Result<BooksPage, Error>) -> Void
    )
}
