//
//  BookQueryRepository.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import Foundation

final class BookQueryRepository: BookRespositoryProtocol {
    
    let storage: CoreDataBooksResponseStorage
    
    init(storage: CoreDataBooksResponseStorage) {
        self.storage = storage
    }
}
