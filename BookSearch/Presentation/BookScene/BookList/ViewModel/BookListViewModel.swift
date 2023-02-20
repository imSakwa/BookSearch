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
        let bookList: BehaviorRelay<[Book]>
    }
    
    
    private var searchWord: String = ""
    private var bookList = BehaviorRelay<[Book]>(value: [])
    private var booksPage: [BooksPage] = []
    private let disposebag = DisposeBag()
    private let useCase: SearchBookUseCase
    private var totalPage: Int = 0
    private var currentPage: Int = 1
    private var hasMorePage: Bool { currentPage < totalPage }
    private var nextPage: Int { hasMorePage ? currentPage + 10 : currentPage }
    
    
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
                self?.load()
            })
            .disposed(by: disposebag)
        
        return Output(bookList: bookList)
    }
    
    func load() {
        let requestValue = SearchBookUseCaseRequestValue(query: searchWord, start: nextPage)
        useCase.execute(requestValue: requestValue) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let booksPage):
                print(booksPage)
                self.currentPage = booksPage.start
                self.totalPage = booksPage.total
                self.booksPage = self.booksPage
                    .filter {
                        $0.start != booksPage.start
                    }
                    + [booksPage]

                self.bookList.accept(self.booksPage.flatMap { $0.books }.map { Book(title: $0.title, description: $0.description, imageStr: $0.imageStr, link: $0.link, author: $0.author, publisher: $0.publisher, publishDate: $0.publishDate, discount: $0.discount)})
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func reset() {
        currentPage = 1
        totalPage = 0
        booksPage.removeAll()
    }
    
    func getBookInfo(index: Int) -> Book {
        return (booksPage.flatMap { $0.books })[index]
    }
    
    func getBookListCount() -> Int { return bookList.value.count }
}
