//
//  BookListViewModel.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

import RxCocoa
import RxSwift

final class BookListViewModel: DefaultViewModel {
    struct Input {
        let searchWord: Driver<String>
    }
    
    struct Output {
//        let bookList: Driver</
    }
    
    private var booksPage = [BooksPage]()
    private let disposebag = DisposeBag()
    private let useCase: SearchBookUseCase
    
    
    init(useCase: SearchBookUseCase) {
        self.useCase = useCase
    }
}

extension BookListViewModel {
    func transform(input: Input) -> Output {
        input.searchWord
            .drive(onNext: { [weak self] value in
                let requestValue = SearchBookUseCaseRequestValue(query: value)
                
                self?.useCase.execute(requestValue: requestValue) { [weak self] result in
                    switch result {
                    case .success(let booksPage):
                        self?.booksPage = booksPage
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
            .disposed(by: disposebag)
        
        return Output()
    }
}
