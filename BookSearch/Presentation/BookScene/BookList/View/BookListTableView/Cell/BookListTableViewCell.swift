//
//  BookListTableViewCell.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/12.
//

import UIKit

import SnapKit

final class BookListTableViewCell: UITableViewCell {
    static let identifier = String(describing: BookListTableViewCell.self)
    static let height = CGFloat(200)
    
    private lazy var bookImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var bookTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var bookAuthor: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var bookPublisher: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private lazy var bookPubDate: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private lazy var bookDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension BookListTableViewCell {
    func setupView(book: Book) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: book.imageStr)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.bookImage.image = image
                    }
                }
            }
        }
        bookTitle.text = book.title
        bookAuthor.text = book.author
        bookPublisher.text = book.publisher
        bookPubDate.adjustDateformat(dateStr: book.publishDate)
        bookDescription.text = book.description
    }
    
    private func setupViewLayout() {
        [bookImage, bookTitle, bookAuthor, bookPublisher, bookPubDate, bookDescription]
            .forEach { contentView.addSubview($0) }
              
        
        bookImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(90)
            $0.height.equalTo(170)
        }
        
        bookTitle.snp.makeConstraints {
            $0.leading.equalTo(bookImage.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }
        
        bookAuthor.snp.makeConstraints {
            $0.leading.equalTo(bookTitle)
            $0.top.equalTo(bookTitle.snp.bottom).offset(8)
        }
        
        bookPublisher.snp.makeConstraints {
            $0.leading.equalTo(bookTitle)
            $0.top.equalTo(bookAuthor.snp.bottom).offset(4)
        }
        
        bookPubDate.snp.makeConstraints {
            $0.leading.equalTo(bookPublisher.snp.trailing).offset(4)
            $0.centerY.equalTo(bookPublisher)
        }
        
        bookDescription.snp.makeConstraints {
            $0.leading.trailing.equalTo(bookTitle)
            $0.top.equalTo(bookPublisher.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(16).priority(.low)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookImage.image = nil
    }
}
