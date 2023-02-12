//
//  DefaultViewModel.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/12.
//

import Foundation

protocol DefaultViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
