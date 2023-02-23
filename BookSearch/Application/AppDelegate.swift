//
//  AppDelegate.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/10.
//

import UIKit
import CoreData

import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let container: Container = {
        let container = Container()
        container.register(CoreDataBooksResponseStorage.self) { _ in
            return CoreDataBooksResponseStorage()
        }
        container.register(BookRespository.self) { resolver in
            let booksResponseStorage = resolver.resolve(CoreDataBooksResponseStorage.self)!
            return BookRespository(storage: booksResponseStorage)
        }
        container.register(SearchBookUseCase.self) { resolver in
            let respository = resolver.resolve(BookRespository.self)!
            return SearchBookUseCase(bookRepository: respository)
        }
        container.register(BookListViewModel.self) { resolver in
            let usecase = resolver.resolve(SearchBookUseCase.self)!
            return BookListViewModel(useCase: usecase)
        }
        container.register(BookListViewController.self) { resolver in
            let viewModel = resolver.resolve(BookListViewModel.self)!
            return BookListViewController(viewModel: viewModel)
        }
        return container
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

