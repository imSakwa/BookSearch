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

protocol BooKListVCProtocol: AnyObject {
    var onBookSelected: ((BookDetailViewModel) -> Void)? { get set }
}

final class BookListViewController: UIViewController, BooKListVCProtocol {
    var onBookSelected: ((BookDetailViewModel) -> Void)?
    
    // MARK: Property
    private let viewModel: BookListViewModel
    private let disposebag = DisposeBag()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: UI Component
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.placeholder = "검색어를 입력해주세요."
        return bar
    }()
    
    private lazy var tableViewVC: BookListTableViewController = {
        let storage = appDelegate.assembler.resolver.resolve(BooksResponseStorage.self)!
        let repository = appDelegate.assembler.resolver.resolve(BookRespositoryProtocol.self)!
        let queryStorage = appDelegate.assembler.resolver.resolve(BookQueryStorage.self)!
        let queryRepository = appDelegate.assembler.resolver.resolve(BookQueryRepositoryProtocol.self)!
        let usecase = appDelegate.assembler.resolver.resolve(SearchBookUseCaseProtocol.self)!
        let viewModel = appDelegate.assembler.resolver.resolve(BookListViewModel.self)!
        let vc = appDelegate.assembler.resolver.resolve(BookListTableViewController.self)!
        return vc
    }()
    
    private lazy var queryTableVC: BookQueryListTableViewController = {
        let viewModel = BookQueryViewModel(
            fetchMaxCount: 10,
            fetchFactory:  makeFetchQueryUseCase
        )
        let vc = BookQueryListTableViewController(viewModel: viewModel)
        return vc
    }()
    
    // MARK: - LifeCycle
    init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        bind()
    }
}

// MARK: - Function
extension BookListViewController {
    func makeFetchQueryUseCase(
        requestValue: FetchRecentBookQueryUseCase.FetchQueryRequestValue,
        completion: @escaping (FetchRecentBookQueryUseCase.ResultValue) -> Void
    ) -> FetchRecentBookQueryUseCase {
        let queryStorage = appDelegate.assembler.resolver.resolve(BookQueryStorage.self)!
        let queryRepository = appDelegate.assembler.resolver.resolve(BookQueryRepositoryProtocol.self)!
        
        return FetchRecentBookQueryUseCase(
            requestValue: requestValue,
            repository: queryRepository,
            completion: completion)
    }
    
    /// BookListViewModel과 바인딩
    private func bind() {
        tableViewVC.tableView.delegate = nil
        tableViewVC.tableView.dataSource = nil
        
        let input = BookListViewModel.Input(
            searchWord: searchBar.rx.text.asDriver(onErrorJustReturn: ""),
            searchClick: searchBar.rx.searchButtonClicked.asDriver(),
            editClick: searchBar.rx.textDidBeginEditing.asDriver(),
            cancelClick: searchBar.rx.cancelButtonClicked.asDriver()
        )
        
        let output = viewModel.transform(input: input)

        output.bookList
            .bind(
                to: tableViewVC.tableView.rx.items(
                    cellIdentifier: BookListTableViewCell.identifier,
                    cellType: BookListTableViewCell.self
                )
            ) {  index, bookData, cell in
                self.searchBar.resignFirstResponder()
                cell.setupView(book: bookData)
            }.disposed(by: disposebag)
        
        tableViewVC.tableView.rx.prefetchRows
            .compactMap(\.last?.row)
            .withUnretained(self)
            .bind(onNext: { vc, row in
                guard row == vc.viewModel.getBookListCount() - 1 else { return }
                vc.viewModel.prefetchRow(queryStr: vc.searchBar.searchTextField.text!)
            })
            .disposed(by: disposebag)
        
        
        output.showQuery
            .bind(onNext: { [weak self] value in
                if !value { self?.searchBar.resignFirstResponder() }
                self?.updateView()
            })
            .disposed(by: disposebag)
                
        tableViewVC.tableView
            .rx.modelSelected(Book.self)
            .subscribe(onNext: { [weak self] book in
                let bookDetailViewModel = BookDetailViewModel(book: book)
                self?.onBookSelected?(bookDetailViewModel)
            })
            .disposed(by: disposebag)
        
        queryTableVC.tableView
            .rx.modelSelected(BookQuery.self)
            .subscribe(onNext: { [weak self] query in
                self?.searchBar.resignFirstResponder()
                self?.updateView()
                self?.viewModel.search(query: query)
                self?.searchBar.text = query.query
            })
            .disposed(by: disposebag)
    }
    
    /// View 초기 세팅
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = searchBar
    }
    
    /// searchBar focusing 상태에 따라 화면 전환
    private func updateView() {
        guard searchBar.isFirstResponder else {
            showBookListVC()
            return
        }
        showQueryTableView()
    }
    
    /// 자식 BookListTableVC 등록
    private func showBookListVC() {
        removeQueryTableVC()
        
        addChild(tableViewVC)
        view.addSubview(tableViewVC.tableView)
        tableViewVC.didMove(toParent: self)
        
        tableViewVC.tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    /// 자식 QueryTableVC 등록
    private func showQueryTableView() {
        removeBookListVC()
        searchBar.showsCancelButton = true
        
        addChild(queryTableVC)
        view.addSubview(queryTableVC.tableView)
        queryTableVC.didMove(toParent: self)
        
        queryTableVC.tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    /// 자식 BookListTableVC 해제
    private func removeBookListVC() {
        tableViewVC.willMove(toParent: nil)
        tableViewVC.removeFromParent()
        tableViewVC.tableView.removeFromSuperview()
    }
    
    /// 자식 QueryTableVC 해제
    private func removeQueryTableVC() {
        searchBar.showsCancelButton = false
        
        queryTableVC.willMove(toParent: nil)
        queryTableVC.removeFromParent()
        queryTableVC.tableView.removeFromSuperview()
    }
}
