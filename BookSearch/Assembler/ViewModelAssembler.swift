//
//  ViewModelAssembler.swift
//  BookSearch
//
//  Created by ChangMin on 2023/03/04.
//

import Foundation

import Swinject

final class ViewModelAssembler: Assembly {
    func assemble(container: Container) {
        container.register(BookListViewModel.self) { resolver in
            let useCase = resolver.resolve(SearchBookUseCaseProtocol.self)!
            return BookListViewModel(useCase: useCase)
        }
        
//        container.register(BookDetailViewModel.self) { resolver in
//            let book = resolver.resolve(Book.self)!
//            return BookDetailViewModel(book: book)
//        }
    }
}
