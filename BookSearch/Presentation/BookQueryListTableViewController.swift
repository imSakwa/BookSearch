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
        
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewModel: BookQueryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension BookQueryListTableViewController {
    // MARK: Functions
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
}
