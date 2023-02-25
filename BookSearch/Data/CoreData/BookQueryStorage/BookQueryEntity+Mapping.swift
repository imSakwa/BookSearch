//
//  BookQueryEntity+Mapping.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import Foundation
import CoreData

extension BookQueryEntity {
    convenience init(query: BookQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.query = query.query
        self.createdAt = Date()
    }
    
    func toDomain() -> BookQuery {
        return .init(query: query ?? "")
    }
}
