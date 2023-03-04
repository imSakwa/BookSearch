//
//  RepositoryAssembler.swift
//  BookSearch
//
//  Created by ChangMin on 2023/03/04.
//

import Foundation

import Swinject

final class RepositoryAssembler: Assembly {
    func assemble(container: Container) {
        container.register(BookRespositoryProtocol.self) { resolver in
            let storage = resolver.resolve(BooksResponseStorage.self)!
            return BookRespository(storage: storage)
        }
        
        container.register(BookQueryRepositoryProtocol.self) { resolver in
            let storage = resolver.resolve(BookQueryStorage.self)!
            return BookQueryRepository(storage: storage)
        }
    }
}
