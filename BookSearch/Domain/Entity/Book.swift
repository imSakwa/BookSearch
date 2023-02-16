//
//  Book.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

struct Book: Codable {
    let title: String
    let description: String
    let imageStr: String
    let link: String
    let author: String
    let publisher: String
    let publishDate: String
    let discount: String
}


struct BooksPage: Codable {
    let total: Int
    let start: Int
    let books: [Book]
}
