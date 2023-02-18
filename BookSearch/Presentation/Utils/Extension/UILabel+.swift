//
//  UILabel+.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/18.
//

import UIKit

extension UILabel {
    func adjustDateformat(dateStr: String) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        
        guard let date = dateformatter.date(from: dateStr)
        else { fatalError("String -> Date 변환 실패") }
        
        dateformatter.dateFormat = "yyyy년 M월 d일"
        self.text = dateformatter.string(from: date)
    }
    
    func adjustNumberformat(numberStr: String) {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        
        guard let number = numberformatter.number(from: numberStr)
        else { fatalError("String -> Number 변환 실패")  }
        
        
        guard let numberStyleStr = numberformatter.string(from: number)
        else { fatalError("Number -> String 변환 실패") }
        
        self.text = numberStyleStr + "원"
    }
}
