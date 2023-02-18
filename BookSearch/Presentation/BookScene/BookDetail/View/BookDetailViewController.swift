//
//  BookDetailViewController.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/16.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class BookDetailViewController: UIViewController {
    
    private let disposebag = DisposeBag()
    private let bookDetailViewModel: BookDetailViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        return scrollView
    }()
    
    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var bookDescriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var bookAuthorAndPublisherLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private lazy var bookPubDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var bookDiscountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
        
    // MARK: - Life Cycle
    init(viewModel: BookDetailViewModel) {
        bookDetailViewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bind()
    }
}

// MARK: - Functions
extension BookDetailViewController {
    private func bind() {
        let input = BookDetailViewModel.Input()
        
        let output = bookDetailViewModel.transform(input: input)
        
        output.imageStr
            .subscribe(onNext: { [weak self] value in
                self?.setBookImage(urlString: value)
            })
            .disposed(by: disposebag)
        
        output.dataZip
            .subscribe(onNext: { [weak self] in
                self?.bookTitleLabel.text = $0
                self?.bookDescriptionLabel.text = $1
                self?.bookAuthorAndPublisherLabel.text = $2
                self?.bookPubDateLabel.adjustDateformat(dateStr: $3)
                self?.bookDiscountLabel.adjustNumberformat(numberStr: $4)
            })
            .disposed(by: disposebag)
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupViewLayout() {
        view.addSubview(scrollView)
        
        [bookImageView, bookTitleLabel, bookDescriptionLabel, bookAuthorAndPublisherLabel,
         bookPubDateLabel, bookDiscountLabel]
            .forEach { scrollView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(300)
        }
        
        bookTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bookImageView.snp.bottom).offset(12)
            $0.height.greaterThanOrEqualTo(18)
            $0.height.lessThanOrEqualTo(24)
            $0.leading.trailing.greaterThanOrEqualToSuperview().inset(36)
        }
        
        bookAuthorAndPublisherLabel.snp.makeConstraints {
            $0.top.equalTo(bookTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        bookPubDateLabel.snp.makeConstraints {
            $0.top.equalTo(bookAuthorAndPublisherLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        bookDiscountLabel.snp.makeConstraints {
            $0.top.equalTo(bookPubDateLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        bookDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bookDiscountLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
            $0.leading.trailing.greaterThanOrEqualToSuperview().inset(36)
        }
    }
    
    private func setBookImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [weak self] in
                    self?.bookImageView.image = UIImage(data: data)
                }
            }
        }
    }
}
