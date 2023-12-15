//
//  BookRespositoryProtocol.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

import RxSwift

protocol BookRespositoryProtocol {
    /// 책 리스트 가져오기
    func fetchBookList(
        query: BookQuery,
        display: Int,
        start: Int,
        sort: BookSort,
        cached: @escaping (BooksPage) -> Void,
        completion: @escaping (Result<BooksPage, Error>) -> Void
    )
    
    func fetchBookList(
        query: BookQuery,
        display: Int,
        start: Int,
        sort: BookSort
    ) -> Observable<Result<BooksPage, Error>>
}
