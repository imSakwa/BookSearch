//
//  BookListTableViewController.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/12.
//

import UIKit

import RxSwift
import SnapKit

final class BookListTableViewController: UITableViewController {
    // MARK: Property
    private let viewModel: BookListViewModel
        
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension BookListTableViewController {
    private func setupView() {
        tableView.register(
            BookListTableViewCell.self,
            forCellReuseIdentifier: BookListTableViewCell.identifier
        )
        
        tableView.estimatedRowHeight = BookListTableViewCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = nil
        tableView.dataSource = nil
    }
}
