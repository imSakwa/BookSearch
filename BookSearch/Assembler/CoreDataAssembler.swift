//
//  CoreDataAssembler.swift
//  BookSearch
//
//  Created by ChangMin on 2023/03/04.
//

import Foundation

import Swinject

final class CoreDataAssembler: Assembly {
    func assemble(container: Container) {
        container.register(CoreDataStorage.self) { _ in CoreDataStorage.shared }
        
        container.register(BooksResponseStorage.self) { resolver in
            let storage = resolver.resolve(CoreDataStorage.self)!
            return CoreDataBooksResponseStorage(storage: storage)
        }
        
        container.register(BookQueryStorage.self) { resolver in
            let storage = resolver.resolve(CoreDataStorage.self)!
            return CoreDataBookQueryStorage(coreDataStorage: storage)
        }
    }
}
