//
//  BookListResponseDTO.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

struct BookDTO: Codable {
    let title: String
    let description: String
    let imageStr: String
    let link: String
    let author: String
    let publisher: String
    let publishDate: String
    let discount: String
    
    enum CodingKeys: String, CodingKey {
        case title, description, link, author, publisher, discount
        case imageStr = "image"
        case publishDate = "pubdate"
    }
}


struct BookListResponseDTO: Codable {
    let total: Int
    let start: Int
    let books: [BookDTO]
    
    enum CodingKeys: String, CodingKey {
        case total, start
        case books = "items"
    }
}

extension BookListResponseDTO {
    func toDomain() -> BooksPage {
        return BooksPage(
            total: total,
            start: start,
            books: books.map { $0.toDomain() }
        )
    }
}

extension BookDTO {
    func toDomain() -> Book {
        return Book(
            title: title,
            description: description,
            imageStr: imageStr,
            link: link,
            author: author,
            publisher: publisher,
            publishDate: publishDate,
            discount: discount
        )
    }
}
