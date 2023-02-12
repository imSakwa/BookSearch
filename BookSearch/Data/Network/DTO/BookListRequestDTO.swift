//
//  BookListRequestDTO.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

struct BookListRequestDTO: Encodable {
    let query: String // 검색어
    let display: Int // 검색 갯수 (기본: 10)
    let start: Int // 검색 시작 위치 (기본: 1)
    let sort: String // 정렬 방식 (sim: 정확도 순, date: 출간일 순)
    
    init(query: String, display: Int?, start: Int?, sort: BookSort?) {
        self.query = query
        self.display = display ?? 10
        self.start = start ?? 1
        self.sort = sort?.rawValue ?? BookSort.sim.rawValue
    }
}

enum BookSort: String {
    case sim = "sim"
    case date = "date"
}
