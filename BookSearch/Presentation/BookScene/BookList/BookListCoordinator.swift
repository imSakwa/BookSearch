//
//  BookListCoordinator.swift
//  BookSearch
//
//  Created by ChangMin on 2023/03/05.
//

import UIKit

final class BookListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showBookListVC()
    }
}

extension BookListCoordinator {
    private func showBookListVC() {
        let bookListVC = appDelegate.assembler.resolver.resolve(BookListViewController.self)!
        bookListVC.onBookSelected = { [weak self] viewModel in
            self?.showBookDetailVC(viewModel: viewModel)
        }
        navigationController.viewControllers = [bookListVC]
    }
    
    private func showBookDetailVC(viewModel: BookDetailViewModel) {
        let bookDetailVC = appDelegate.assembler.resolver.resolve(BookDetailViewController.self)!
        bookDetailVC.bookDetailViewModel = viewModel

        navigationController.pushViewController(bookDetailVC, animated: true)
    }
}

