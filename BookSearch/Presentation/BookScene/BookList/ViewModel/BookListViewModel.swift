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
        let searchWord: Driver<String?>
        let searchClick: Driver<Void>
        let editClick: Driver<Void>
        let cancelClick: Driver<Void>
    }
    
    struct Output {
        let bookList: BehaviorRelay<[Book]>
        let showQuery: PublishRelay<Bool>
    }
    
    // MARK: Property
    private var searchWord = BehaviorRelay<String>(value: "")
    private let showQuery = PublishRelay<Bool>()
    private var bookList = BehaviorRelay<[Book]>(value: [])
    private var booksPage: [BooksPage] = []
    private let disposebag = DisposeBag()
    private let useCase: SearchBookUseCaseProtocol
    private var totalPage: Int = 0
    private var currentPage: Int = 1
    private var hasMorePage: Bool { currentPage < totalPage }
    private let displayNum: Int = 10
    // display 요청 파라미터가 10이여서 + 10 해줌 -> start 파라미터는 단순 검색 시작 위치
    private var nextPage: Int { hasMorePage ? currentPage + displayNum : currentPage }
    
    var isLoading: Bool = false
    // MARK: Init
    init(useCase: SearchBookUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension BookListViewModel {
    // MARK: Input -> Output
    func transform(input: Input) -> Output {
        input.searchWord
            .drive(onNext: { [weak self] value in
                guard let value = value, value != "" else {
                    self?.showQuery.accept(true)
                    return
                }
                self?.searchWord.accept(value)
            })
            .disposed(by: disposebag)
        
        input.searchClick
            .drive(onNext: { [weak self] _ in
                self?.showQuery.accept(false)
                self?.search(query: BookQuery(query: (self?.searchWord.value)!))
            })
            .disposed(by: disposebag)
        
        input.editClick
            .drive(onNext: { [weak self] _ in
                self?.showQuery.accept(true)
            })
            .disposed(by: disposebag)
        
        input.cancelClick
            .drive(onNext: { [weak self] _ in
                self?.showQuery.accept(false)
            })
            .disposed(by: disposebag)
        
        return Output(bookList: bookList, showQuery: showQuery)
    }
    
    /// 검색 결과 페이지 프로퍼티에 저장
    private func appendPage(_ page: BooksPage) {
        currentPage = page.start
        totalPage = page.total
        booksPage = booksPage
            .filter {
                $0.start != page.start
            }
            + [page]
        bookList.accept(booksPage.flatMap { $0.books }.map(Book.init))
    }
    
    /// 검색어를 통해 검색 API 요청
    private func load(query: BookQuery) {
        let requestValue = SearchBookUseCaseRequestValue(
            query: query,
            start: nextPage,
            display: displayNum
        )
        
        if isLoading { return }
        isLoading = true
        useCase.execute(
            requestValue: requestValue,
            cached: appendPage
        ) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let booksPage):
                self.appendPage(booksPage)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// 해당 query로 검색하기
    func search(query: BookQuery) {
        reset()
        load(query: query)
    }
    
    /// 프로퍼티 초기화
    private func reset() {
        currentPage = 1
        totalPage = 0
        booksPage.removeAll()
        
        var array = bookList.value
        array.removeAll()
        bookList.accept(array)
    }
    
    /// Paging 처리
    func prefetchRow(queryStr: String) {
        load(query: BookQuery(query: queryStr))
    }
    
    /// 해당 index의 Book 모델 리턴
    func getBookInfo(index: Int) -> Book {
        return (booksPage.flatMap { $0.books })[index]
    }
    
    /// Book 배열을 담고있는 BehaviorRelay 갯수 리턴
    func getBookListCount() -> Int { return bookList.value.count }
}
