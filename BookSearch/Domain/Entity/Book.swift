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

extension Book {
    init(book: Book) {
        title = book.title
        description = book.description
        imageStr = book.imageStr
        link = book.link
        author = book.author
        publisher = book.publisher
        publishDate = book.publishDate
        discount = book.discount
    }
}


struct BooksPage: Codable {
    let total: Int
    let start: Int
    let books: [Book]
}
