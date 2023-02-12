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
        bar.placeholder = "검색어를 입력해주세요."
        return bar
    }()
    
    private lazy var tableViewVC: BookListTableViewController = {
        let vc = BookListTableViewController(viewModel: BookListViewModel())
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setupViewLayout()
    }
    
    init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension BookListViewController {
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
    
    private func executeSearch(word: String) {
//        usecase.execute(requestValue: SearchBookUseCaseRequestValue(query: word)) { result in
//            switch result {
//            case .success(let data):
//                print(data)
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}

