//
//  BookQueryViewModel.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import Foundation

import RxCocoa
import RxSwift

final class BookQueryViewModel: DefaultViewModel {
    // MARK: Input/Output
    struct Input { }
    
    struct Output {
        let queryItems: BehaviorSubject<[BookQuery]>
    }
    
    // MARK: Property
    typealias FetchRecentBookQueryUseCaseFactory = (
        FetchRecentBookQueryUseCase.FetchQueryRequestValue,
        @escaping (FetchRecentBookQueryUseCase.ResultValue) -> Void
    ) -> FetchRecentBookQueryUseCase
    private let fetchMaxCount: Int
    private let fetchFactory: FetchRecentBookQueryUseCaseFactory
    private let queryItems = BehaviorSubject<[BookQuery]>(value: [])
    
    // MARK: Init
    init(fetchMaxCount: Int,
         fetchFactory: @escaping FetchRecentBookQueryUseCaseFactory) {
        self.fetchMaxCount = fetchMaxCount
        self.fetchFactory = fetchFactory
    }
}

extension BookQueryViewModel {
    /// Input -> Output
    func transform(input: Input) -> Output {
        return Output(queryItems: queryItems)
    }
    
    func updateQuery() {
        let request = FetchRecentBookQueryUseCase.FetchQueryRequestValue(maxCount: fetchMaxCount)
        let completion: (FetchRecentBookQueryUseCase.ResultValue) -> Void = { result in
            switch result {
            case .success(let query):
                self.queryItems.onNext(query)
            case .failure(_):
                break
            }
        }
        let useCase = fetchFactory(request, completion)
        useCase.fetchQuery()
    }
}
