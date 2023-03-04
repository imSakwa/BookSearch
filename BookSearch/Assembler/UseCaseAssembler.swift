//
//  UseCaseAssembler.swift
//  BookSearch
//
//  Created by ChangMin on 2023/03/04.
//

import Foundation

import Swinject

final class UseCaseAssember: Assembly {
    func assemble(container: Container) {
        container.register(SearchBookUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(BookRespositoryProtocol.self)!
            let queryRepository = resolver.resolve(BookQueryRepositoryProtocol.self)!
            return SearchBookUseCase(bookRepository: repository,
                                     bookQueryRepository: queryRepository)
        }
        
//        container.register(FetchRecentBookQueryUseCase.self) { _ in
//            FetchRecentBookQueryUseCase(requestValue: <#T##FetchRecentBookQueryUseCase.FetchQueryRequestValue#>, repository: <#T##BookQueryRepositoryProtocol#>, completion: <#T##(FetchRecentBookQueryUseCase.ResultValue) -> Void#>)
//        }
    }
}
