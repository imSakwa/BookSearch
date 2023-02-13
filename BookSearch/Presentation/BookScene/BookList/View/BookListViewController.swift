//
//  ViewController.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/10.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class BookListViewController: UIViewController {
    
    private let viewModel: BookListViewModel
    private let disposebag = DisposeBag()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.placeholder = "검색어를 입력해주세요."
        return bar
    }()
    
    private lazy var tableViewVC: BookListTableViewController = {
        let repository = BookRespository()
        let usecase = SearchBookUseCase(bookRepository: repository)
        let viewModel = BookListViewModel(useCase: usecase)
        let vc = BookListTableViewController(viewModel: viewModel)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setupViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bind()
    }
    
    init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension BookListViewController {
    private func bind() {
        let input = BookListViewModel.Input(
            searchWord: searchBar.rx.text.orEmpty.asDriver()
        )
        
        let output = viewModel.transform(input: input)

        output.bookList
            .bind(
                to: tableViewVC.tableView.rx.items(
                    cellIdentifier: BookListTableViewCell.identifier,
                    cellType: BookListTableViewCell.self
                )
            ) {  index, bookData, cell in
                cell.setupView(book: bookData)
            }.disposed(by: disposebag)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
    }
    
    private func setupViewLayout() {
        addChild(tableViewVC)
        view.addSubview(tableViewVC.tableView)
        tableViewVC.didMove(toParent: self)
        
        tableViewVC.tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

