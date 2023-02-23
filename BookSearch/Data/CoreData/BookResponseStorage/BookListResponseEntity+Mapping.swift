//
//  BookListResponseEntity+Mapping.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/23.
//

import Foundation
import CoreData

extension BookListResponseEntity {
    func toDTO() -> BookListResponseDTO {
        return .init(
            total: Int(total),
            start: Int(start),
            books: book?.allObjects.map { ($0 as! BookResponseEntity).toDTO() } ?? []
        )
    }
}

extension BookResponseEntity {
    func toDTO() -> BookDTO {
        return .init(
            title: title!,
            description: descrip!,
            imageStr: imageStr!,
            link: link!,
            author: author!,
            publisher: publisher!,
            publishDate: publishDate!,
            discount: discount!
        )
    }
}
