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

extension BookListRequestDTO {
    func toDTO(context: NSManagedObjectContext) -> BookListRequestEntity {
        let entity = BookListRequestEntity(context: context)
        entity.query = query
        entity.sort = sort
        entity.start = Int64(start)
        entity.display = Int64(display)
        return entity
    }
}

extension BookListResponseDTO {
    func toDTO(context: NSManagedObjectContext) -> BookListResponseEntity {
        let entity = BookListResponseEntity(context: context)
        entity.total = Int64(total)
        entity.start = Int64(start)
        books.forEach {
            entity.addToBook($0.toEntity(context: context))
        }
        return entity
    }
}

extension BookDTO {
    func toEntity(context: NSManagedObjectContext) -> BookResponseEntity {
        let entity = BookResponseEntity(context: context)
        entity.discount = discount
        entity.publishDate = publishDate
        entity.publisher = publisher
        entity.author = author
        entity.link = link
        entity.imageStr = imageStr
        entity.descrip = description
        entity.title = title
        return entity
    }
}
