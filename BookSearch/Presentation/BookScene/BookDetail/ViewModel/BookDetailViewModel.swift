//
//  BookDetailViewModel.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/17.
//

import Foundation

import RxCocoa
import RxSwift

final class BookDetailViewModel: DefaultViewModel {
    struct Input { }
    
    struct Output {
        let imageStr: BehaviorRelay<String>
        let dataZip: Observable<(String, String, String, String, String)>
    }
    
    private let disposebag = DisposeBag()
    private let book: Book
    
    init(book: Book) {
        self.book = book
    }
}

extension BookDetailViewModel {
    func transform(input: Input) -> Output {
        let imageStr = BehaviorRelay<String>(value: book.imageStr)
        let titleStr = BehaviorRelay<String>(value: book.title)
        let descriptionStr = BehaviorRelay<String>(value: book.description)
        let authorAndPublishStr = BehaviorRelay<String>(value: "\(book.author) | \(book.publisher)")
        let pubDateStr = BehaviorRelay<String>(value: book.publishDate)
        let discountStr = BehaviorRelay<String>(value: book.discount)
        
        let dataZip = BehaviorRelay
            .zip(titleStr, descriptionStr, authorAndPublishStr, pubDateStr, discountStr)

        return Output(imageStr: imageStr, dataZip: dataZip)
    }
}
