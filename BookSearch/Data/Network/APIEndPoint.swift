//
//  APIEndPoint.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

struct APIEndPoint {
    static func getBookList(with: BookListRequestDTO) -> EndPoint<BookListResponseDTO> {
        let headers: [String: String] = [
            "X-Naver-Client-Id": "HyupDtvkERTZC9bRBvms",
            "X-Naver-Client-Secret": "T2Ojn_xxfL"
        ]
        return EndPoint(baseURL: "https://openapi.naver.com/v1/",
                        path: "search/book",
                        method: .get,
                        queryParameters: with,
                        headers: headers)
    }
}
