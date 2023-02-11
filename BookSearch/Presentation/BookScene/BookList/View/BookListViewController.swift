//
//  ViewController.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/10.
//

import UIKit

import SnapKit

final class BookListViewController: UIViewController {
    
    private let viewModel: BookListViewModel
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.placeholder = viewModel.sample
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupViewLayout()
    }
    
    init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension BookListViewController {
    private func setupViewLayout() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
    }
}

