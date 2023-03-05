//
//  AppCoordinator.swift
//  BookSearch
//
//  Created by ChangMin on 2023/03/05.
//

import UIKit

protocol Coordinator : AnyObject {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }
    
    func start() {
        showBookListCoordinator()
    }
}

extension AppCoordinator {
    private func showBookListCoordinator() {
        let bookListCoordinator = BookListCoordinator(navigationController: navigationController)
        bookListCoordinator.start()
        childCoordinators.append(bookListCoordinator)
    }
}
