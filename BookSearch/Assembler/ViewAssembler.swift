//
//  ViewAssembler.swift
//  BookSearch
//
//  Created by ChangMin on 2023/03/04.
//

import Foundation

import Swinject

final class ViewAssembler: Assembly {
    func assemble(container: Container) {
        container.register(BookListViewController.self) { resolver in
            let viewModel = resolver.resolve(BookListViewModel.self)!
            return BookListViewController(viewModel: viewModel)
        }
        
        container.register(BookListTableViewController.self) { resolver in
            let viewModel = resolver.resolve(BookListViewModel.self)!
            return BookListTableViewController(viewModel: viewModel)
        }
        
        container.register(BookDetailViewController.self) { resolver in
            let viewModel = resolver.resolve(BookDetailViewModel.self)!
            return BookDetailViewController(viewModel: viewModel)
        }
    }
}
