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
    // MARK: Input/Output
    struct Input {
        let searchWord: Driver<String>
    }
    
    struct Output {
        let bookList: BehaviorRelay<[Book]>
    }
    
    // MARK: Property
    private var searchWord = BehaviorRelay<String>(value: "")
    private var bookList = BehaviorRelay<[Book]>(value: [])
    private var booksPage: [BooksPage] = []
    private let disposebag = DisposeBag()
    private let useCase: SearchBookUseCase
    private var totalPage: Int = 0
    private var currentPage: Int = 1
    private var hasMorePage: Bool { currentPage < totalPage }
    private let displayNum: Int = 10
    // display 요청 파라미터가 10이여서 + 10 해줌 -> start 파라미터는 단순 검색 시작 위치
    private var nextPage: Int { hasMorePage ? currentPage + displayNum : currentPage }
    
    // MARK: Init
    init(useCase: SearchBookUseCase) {
        self.useCase = useCase
    }
}

extension BookListViewModel {
    // MARK: Input -> Output
    func transform(input: Input) -> Output {
        input.searchWord
            .debounce(.milliseconds(300))
            .distinctUntilChanged()
            .drive(onNext: { [weak self] value in
                self?.searchWord.accept(value)
                self?.load()
            })
            .disposed(by: disposebag)
        
        return Output(bookList: bookList)
    }
    
    /// 검색어를 통해 검색 API 요청
    func load() {
        let requestValue = SearchBookUseCaseRequestValue(
            query: searchWord.value,
            start: nextPage,
            display: displayNum
        )
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

                self.bookList.accept(self.booksPage.flatMap { $0.books }.map(Book.init))
                
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
    
    /// 해당 index의 Book 모델 리턴
    func getBookInfo(index: Int) -> Book {
        return (booksPage.flatMap { $0.books })[index]
    }
    
    /// Book 배열을 담고있는 BehaviorRelay 갯수 리턴
    func getBookListCount() -> Int { return bookList.value.count }
}
