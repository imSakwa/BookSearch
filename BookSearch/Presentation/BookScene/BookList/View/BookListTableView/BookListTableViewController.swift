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
    private let viewModel: BookListViewModel
        
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
    }
}

extension BookListTableViewController {
    override func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat { return BookListTableViewCell.height }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int { return 10 }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BookListTableViewCell.identifier,
            for: indexPath
        ) as? BookListTableViewCell else { return UITableViewCell() }
        
        cell.setupView()
        return cell
    }
}
