//
//  HomePostVC.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit
import RxSwift

class HomePostVC: BaseVC {
    lazy var searchBar: SearchComponent = SearchComponent()

    private lazy var refreshControl = UIRefreshControl() ~!~ {
        $0.tintColor = .black
    }

    private lazy var tableView = UITableView(frame: .zero, style: .grouped) ~!~ {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.refreshControl = refreshControl
        $0.registerCells(PostCell.self)
    }

    let viewModel: HomePostVMProtocol
    init(viewModel: HomePostVMProtocol = HomePostVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.addSubviews(tableView)
        setupConstraints()
        setupEvents()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupEvents() {
        self.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe({ [weak self] _ in
                // reload
            })
            .disposed(by: disposeBag)

        let section = Observable.just([1,2,3,4,5,6]).map { (data) -> TableSectionViewModelProtocol in
            return TableSectionViewModel(entries: data) { (_, data, cell: PostCell) in
                cell.bindData(ownerName: "Test \(data)", date: "2022-08-07T17:36:58.516Z", content: "abc")
            } onSelect: { _, data in

            }.asProtocol
        }

        tableView.rx.items(section: section)
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

extension HomePostVC: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        UITableView.automaticDimension
    }
}
