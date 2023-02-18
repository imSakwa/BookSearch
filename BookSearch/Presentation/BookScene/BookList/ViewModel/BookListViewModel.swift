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
        let endEdit: Driver<Void>
    }
    
    struct Output {
        let bookList: PublishRelay<[Book]>
    }
    
    private var searchWord: String = ""
    private var bookList = PublishRelay<[Book]>()
    private var booksPage: [BooksPage] = []
    private let disposebag = DisposeBag()
    private let useCase: SearchBookUseCase
    private var totalPage: Int = 0
    private var currentPage: Int = 0
    
    
    init(useCase: SearchBookUseCase) {
        self.useCase = useCase
    }
}

extension BookListViewModel {
    func transform(input: Input) -> Output {
        input.searchWord
            .drive(onNext: { [weak self] value in
                self?.searchWord = value
            })
            .disposed(by: disposebag)
        
        input.endEdit
            .drive(onNext: { [weak self] _ in
                let requestValue = SearchBookUseCaseRequestValue(query: self!.searchWord)

                self?.useCase.execute(requestValue: requestValue) { [weak self] result in
                    switch result {
                    case .success(let booksPage):
                        self?.currentPage = booksPage.start
                        self?.totalPage = booksPage.total
                        self?.bookList.accept(booksPage.books)
                        self?.booksPage = (self?.booksPage
                            .filter { $0.start != booksPage.start } ?? [])
                            + [booksPage]


                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
            .disposed(by: disposebag)
        
        return Output(bookList: bookList)
    }
    
    func getBookInfo(index: Int) -> Book {
        return (booksPage.flatMap { $0.books })[index]
    }
}
