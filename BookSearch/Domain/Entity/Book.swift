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
    
    init(title: String, description: String, imageStr: String, link: String, author: String, publisher: String, publishDate: String, discount: String) {
        self.title = title
        self.description = description
        self.imageStr = imageStr
        self.link = link
        self.author = author
        self.publisher = publisher
        self.publishDate = publishDate
        self.discount = discount
    }
}


struct BooksPage: Codable {
    let total: Int
    let start: Int
    let books: [Book]
}
