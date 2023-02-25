//
//  BookQueryListTableViewCell.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import UIKit

import SnapKit

final class BookQueryListTableViewCell: UITableViewCell {
    // MARK: Property
    static let identifier = String(describing: BookQueryListTableViewCell.self)
    static let height = CGFloat(35)
    
    // MARK: UI Component
    private lazy var titleLabel: UILabel = {
        return UILabel(frame: .zero)
    }()
    
    // MARK: LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        setupView()
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension BookQueryListTableViewCell {
    private func setupViewLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
}


