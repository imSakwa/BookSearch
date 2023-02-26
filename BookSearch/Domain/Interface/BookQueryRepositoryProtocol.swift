//
//  BookQueryRepositoryProtocol.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import Foundation

protocol BookQueryRepositoryProtocol {
    
    /// 최근 query 가져오기
    /// - Parameters:
    ///   - maxCount: 최대 Query 개수
    ///   - completion: 성공시 가져온 BookQuery 배열 전달, 실패 시 Error 전달
    func fetchRecentQueries(
        maxCount: Int,
        completion: @escaping (Result<[BookQuery], Error>) -> Void
    )
    
    /// 최근 Query 저장하기
    /// - Parameters:
    ///   - query: 저장할 Query
    ///   - completion: 성공 시 BookQuery 전달, 실패 시 Error 전달
    func saveRecentQuery(
        query: BookQuery,
        completion: @escaping (Result<BookQuery, Error>)->Void
    )
}
