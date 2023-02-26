//
//  BookQueryListTableViewController.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class BookQueryListTableViewController: UITableViewController {
    // MARK: Property
    private let viewModel: BookQueryViewModel
    private let disposebag = DisposeBag()
        
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateQuery()
    }
    
    init(viewModel: BookQueryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Functions
extension BookQueryListTableViewController {
    private func setupView() {
        tableView.register(
            BookQueryListTableViewCell.self,
            forCellReuseIdentifier: BookQueryListTableViewCell.identifier
        )
        
        tableView.estimatedRowHeight = BookQueryListTableViewCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    private func bind() {
        let input = BookQueryViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.queryItems
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: BookQueryListTableViewCell.identifier,
                    cellType: BookQueryListTableViewCell.self
                )
            ) { index, query, cell in
                cell.setupView(query: query)
            }
            .disposed(by: disposebag)
    }
}
